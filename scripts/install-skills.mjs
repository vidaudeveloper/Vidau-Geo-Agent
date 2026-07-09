#!/usr/bin/env node
/**
 * Batch-install all VidAU GEO Agent skills.
 *
 * Local mode (default): copy skill dirs from this repo into ~/.hermes/skills/vidau-geo/.
 * No raw.githubusercontent.com requests — avoids GitHub CDN 429 rate limits.
 *
 * Remote mode (--remote): install via GitHub identifier (Contents API).
 * From-GitHub mode (--from-github): fetch manifest.json via GitHub API (no clone, no raw CDN).
 * From-CDN mode (--from-cdn): fetch manifest + skill files from geo.vidau.ai/skills.
 *
 * Usage:
 *   pnpm skills:install
 *   node scripts/install-skills.mjs --force
 *   node scripts/install-skills.mjs --remote --force
 *   node scripts/install-skills.mjs --from-github --remote --force
 *   node scripts/install-skills.mjs --from-cdn --force
 */
import { spawnSync } from "node:child_process";
import { cp, mkdir, readFile, readdir, rm, writeFile } from "node:fs/promises";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), "..");

const repo = (process.env.SKILLS_GITHUB_REPO ?? "vidaudeveloper/Vidau-Geo-Agent").replace(
  /\/+$/,
  ""
);
const category = process.env.SKILLS_INSTALL_CATEGORY ?? "vidau-geo";
const cdnBase = (process.env.SKILLS_CDN_BASE ?? "https://geo.vidau.ai/skills").replace(/\/+$/, "");
const force = process.argv.includes("--force") || process.env.SKILLS_INSTALL_FORCE === "1";
const remote = process.argv.includes("--remote") || process.env.SKILLS_INSTALL_REMOTE === "1";
const fromGithub =
  process.argv.includes("--from-github") || process.env.SKILLS_INSTALL_FROM_GITHUB === "1";
const fromCdn = process.argv.includes("--from-cdn") || process.env.SKILLS_INSTALL_FROM_CDN === "1";
const cli = process.env.SKILLS_CLI?.trim() || "hermes";
const hermesHome = process.env.HERMES_HOME?.trim() || join(homedir(), ".hermes");

const SKILL_EXTRA_FILES = {
  "vidau-geo-compose": ["references/compose-params.md", "references/seo-keyword-recommend.md"],
};
const PACK_REFS = ["mcp-prerequisites.md", "mcp-user-not-connected.md"];

function parseManifestJson(raw) {
  const data = JSON.parse(raw);
  return (data.skills ?? [])
    .filter((s) => s.id && s.path)
    .map((s) => ({ id: s.id, path: s.path }));
}

async function parseManifest() {
  const raw = await readFile(join(repoRoot, "manifest.json"), "utf8");
  return parseManifestJson(raw);
}

async function fetchManifestFromGitHub() {
  const branch = process.env.SKILLS_GITHUB_BRANCH ?? "main";
  const url = `https://api.github.com/repos/${repo}/contents/manifest.json?ref=${branch}`;
  const resp = await fetch(url, {
    headers: {
      Accept: "application/vnd.github+json",
      "User-Agent": "vidau-geo-skill-install",
      ...(process.env.GITHUB_TOKEN ? { Authorization: `Bearer ${process.env.GITHUB_TOKEN}` } : {}),
    },
  });
  if (!resp.ok) {
    throw new Error(`GitHub API returned ${resp.status} for manifest.json`);
  }
  const data = await resp.json();
  const raw = Buffer.from(data.content, "base64").toString("utf8");
  return parseManifestJson(raw);
}

async function fetchManifestFromCdn() {
  const resp = await fetch(`${cdnBase}/manifest.json`, {
    headers: { "User-Agent": "vidau-geo-skill-install" },
  });
  if (!resp.ok) {
    throw new Error(`CDN returned ${resp.status} for manifest.json`);
  }
  return parseManifestJson(await resp.text());
}

async function mergePackReferences(dest) {
  const packRefs = join(repoRoot, "references");
  const destRefs = join(dest, "references");
  await mkdir(destRefs, { recursive: true });
  let entries;
  try {
    entries = await readdir(packRefs);
  } catch {
    return;
  }
  for (const name of entries) {
    await cp(join(packRefs, name), join(destRefs, name), { force: true });
  }
}

async function downloadUrl(url) {
  const resp = await fetch(url, { headers: { "User-Agent": "vidau-geo-skill-install" } });
  if (!resp.ok) {
    throw new Error(`GET ${url} → ${resp.status}`);
  }
  return Buffer.from(await resp.arrayBuffer());
}

async function installLocal(skill) {
  const src = join(repoRoot, skill.path);
  const dest = join(hermesHome, "skills", category, skill.id);
  await rm(dest, { recursive: true, force: true });
  await mkdir(dirname(dest), { recursive: true });
  await cp(src, dest, { recursive: true });
  await mergePackReferences(dest);
}

async function installFromCdn(skill) {
  const dest = join(hermesHome, "skills", category, skill.id);
  await rm(dest, { recursive: true, force: true });
  await mkdir(join(dest, "references"), { recursive: true });

  const skillMd = await downloadUrl(`${cdnBase}/${skill.path}/SKILL.md`);
  await writeFile(join(dest, "SKILL.md"), skillMd);

  for (const rel of SKILL_EXTRA_FILES[skill.path] ?? []) {
    const body = await downloadUrl(`${cdnBase}/${skill.path}/${rel}`);
    const out = join(dest, rel);
    await mkdir(dirname(out), { recursive: true });
    await writeFile(out, body);
  }

  for (const name of PACK_REFS) {
    const body = await downloadUrl(`${cdnBase}/references/${name}`);
    await writeFile(join(dest, "references", name), body);
  }
}

function installRemote(skill) {
  const identifier = `${repo}/${skill.path}`;
  const args = ["skills", "install", identifier, "--yes", "--category", category];
  if (force) args.push("--force");
  return spawnSync(cli, args, { stdio: "inherit", encoding: "utf8" });
}

async function main() {
  const skills = fromCdn
    ? await fetchManifestFromCdn()
    : fromGithub
      ? await fetchManifestFromGitHub()
      : await parseManifest();

  const mode = fromCdn
    ? "CDN copy"
    : fromGithub
      ? "GitHub API manifest + remote install"
      : remote
        ? "remote (GitHub API)"
        : "local copy";

  console.info(
    `[skills:install] ${mode}: ${skills.length} skill(s) → ${hermesHome}/skills/${category}/\n`
  );

  let failed = 0;
  const useRemote = remote || fromGithub;
  for (const skill of skills) {
    console.info(`→ ${skill.id}`);
    if (fromCdn) {
      try {
        await installFromCdn(skill);
        console.info(`✓ ${skill.id}\n`);
      } catch (err) {
        console.error(`✗ ${skill.id}: ${err.message}`);
        failed += 1;
      }
    } else if (useRemote) {
      const r = installRemote(skill);
      if (r.status !== 0) {
        console.error(`✗ ${skill.id} failed (exit ${r.status})`);
        failed += 1;
      } else {
        console.info(`✓ ${skill.id}\n`);
      }
    } else {
      try {
        await installLocal(skill);
        console.info(`✓ ${skill.id}\n`);
      } catch (err) {
        console.error(`✗ ${skill.id}: ${err.message}`);
        failed += 1;
      }
    }
  }

  if (failed) {
    console.error(`[skills:install] done with ${failed} failure(s)`);
    process.exit(1);
  }
  console.info("[skills:install] all skills installed");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
