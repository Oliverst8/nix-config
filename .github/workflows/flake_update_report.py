#!/usr/bin/env python3
# Renders the flake-update PR body from the artifacts of flake-update.yml.
import argparse
import datetime as dt
import json
import os
import re
from pathlib import Path

BANNER_START = "<!-- latest-attempt:start -->"
BANNER_END = "<!-- latest-attempt:end -->"
BODY_LIMIT = 60000  # GitHub caps PR bodies at 65536 chars

ANSI = re.compile(r"\x1b\[[0-9;?]*[A-Za-z]")
WARN_MARKERS = ("evaluation warning:", "trace: warning:", "warning:")
WARN_NOISE = (
    "Git tree",
    "is dirty",
    "ignoring untrusted",
    "unknown setting",
    "error (ignored)",
    "download buffer is full",
    "you don't have Internet access",
)


def load_json(path):
    try:
        return json.loads(Path(path).read_text())
    except (OSError, ValueError):
        return None


def fmt_date(ts):
    return dt.datetime.fromtimestamp(ts, dt.timezone.utc).strftime("%Y-%m-%d") if ts else "?"


def fmt_size(n):
    if not n:
        return "–"
    for unit in ("B", "KiB", "MiB", "GiB"):
        if n < 1024 or unit == "GiB":
            return f"{n:.1f} {unit}" if unit != "B" else f"{n} B"
        n /= 1024


def fmt_duration(s):
    return f"{s // 60}m {s % 60:02d}s" if s is not None else "–"


# ---------- flake.lock diff ----------

def compare_url(locked, old_rev, new_rev):
    t = locked.get("type")
    if t == "github":
        return f"https://github.com/{locked['owner']}/{locked['repo']}/compare/{old_rev}...{new_rev}"
    if t == "gitlab":
        owner = locked["owner"].replace("%2F", "/")
        return f"https://gitlab.com/{owner}/{locked['repo']}/-/compare/{old_rev}...{new_rev}"
    if t == "git":
        m = re.match(r"https://github\.com/([^/]+/[^/.]+)", locked.get("url", ""))
        if m:
            return f"https://github.com/{m.group(1)}/compare/{old_rev}...{new_rev}"
    return None


def lock_diff(old, new):
    old_nodes = (old or {}).get("nodes", {})
    new_nodes = (new or {}).get("nodes", {})
    rows = []
    for name in sorted(set(old_nodes) | set(new_nodes)):
        if name == "root":
            continue
        o = old_nodes.get(name, {}).get("locked")
        n = new_nodes.get(name, {}).get("locked")
        if o and n and o.get("narHash") == n.get("narHash"):
            continue
        rows.append((name, o, n))
    if not rows:
        return "_No inputs changed._\n"
    out = ["| Input | Old | New | Changes |", "|---|---|---|---|"]
    for name, o, n in rows:
        def cell(l):
            if not l:
                return "–"
            rev = (l.get("rev") or "")[:8] or l.get("type", "")
            return f"`{rev}` {fmt_date(l.get('lastModified'))}"
        link = ""
        if o and n and o.get("rev") and n.get("rev"):
            url = compare_url(n, o["rev"], n["rev"])
            link = f"[compare]({url})" if url else ""
        elif not o:
            link = "added"
        elif not n:
            link = "removed"
        out.append(f"| `{name}` | {cell(o)} | {cell(n)} | {link} |")
    return "\n".join(out) + "\n"


# ---------- build log parsing ----------

def read_log(path):
    try:
        return [ANSI.sub("", l.rstrip()) for l in Path(path).read_text(errors="replace").splitlines()]
    except OSError:
        return []


def parse_warnings(lines):
    warnings, i = [], 0
    while i < len(lines):
        line = lines[i]
        idx = next((line.find(m) for m in WARN_MARKERS if m in line), -1)
        if idx >= 0 and not any(n in line for n in WARN_NOISE):
            block = [line[idx:]]
            # indented continuation lines belong to the same warning
            while i + 1 < len(lines) and lines[i + 1].startswith((" ", "\t")) and lines[i + 1].strip() and len(block) < 15:
                i += 1
                block.append(lines[i])
            text = "\n".join(block)
            if text not in warnings:
                warnings.append(text)
        i += 1
    return warnings


def parse_error(lines):
    start = next((i for i, l in enumerate(lines) if l.lstrip().startswith("error:")), None)
    excerpt = lines[start:start + 80] if start is not None else lines[-40:]
    return "\n".join(excerpt)


# ---------- package diff ----------

def pkg_map(entries):
    m = {}
    for e in entries or []:
        if isinstance(e, dict) and e.get("name"):
            m.setdefault(e["name"], set()).add(e.get("version") or "")
    return m


def pkg_diff(old, new):
    if not old or not new:
        return None
    lines = []
    ok, nk = old.get("kernel"), new.get("kernel")
    if ok != nk:
        lines.append(f"**Kernel:** `{ok}` → `{nk}`\n")
    rows = []
    for scope in ("system", "home"):
        o, n = pkg_map(old.get(scope)), pkg_map(new.get(scope))
        for name in sorted(set(o) | set(n)):
            ov = ", ".join(sorted(o.get(name, []))) or None
            nv = ", ".join(sorted(n.get(name, []))) or None
            if ov != nv:
                rows.append(f"| {scope} | `{name}` | {ov or '–'} | {nv or '–'} |")
    if rows:
        lines += ["| Scope | Package | Old | New |", "|---|---|---|---|", *rows]
    return "\n".join(lines) + "\n" if lines else "_No top-level package changes._\n"


# ---------- report ----------

def details(summary, body, code=False):
    inner = f"```\n{body}\n```" if code else body
    return f"<details><summary>{summary}</summary>\n\n{inner}\n\n</details>\n"


def collect_host(artifacts, host):
    d = artifacts / f"result-{host}"
    meta = load_json(d / "meta.json") or {}
    log = read_log(d / "build.log")
    passed = meta.get("status") == "success"
    return {
        "host": host,
        "found": bool(meta),
        "passed": passed,
        "duration": meta.get("duration"),
        "closure": meta.get("closure_size"),
        "warnings": parse_warnings(log),
        "error": None if passed else (parse_error(log) if log else "No build log. The job was cancelled or timed out."),
        "pkgs": pkg_diff(load_json(d / "pkgs-old.json"), load_json(d / "pkgs-new.json")),
    }


def render(hosts, old_lock, new_lock, run_url, date):
    passed = [h for h in hosts if h["passed"]]
    failed = [h for h in hosts if not h["passed"]]
    nixpkgs = (new_lock or {}).get("nodes", {}).get("nixpkgs", {}).get("locked", {})
    status = "✅" if not failed else "❌"

    out = [f"## {status} Flake update {date}\n"]
    out.append(
        f"**{len(passed)}/{len(hosts)} hosts built** · nixpkgs `{(nixpkgs.get('rev') or '?')[:8]}` "
        f"from {fmt_date(nixpkgs.get('lastModified'))} · [workflow run]({run_url})\n"
    )

    out.append("### Hosts\n")
    out.append("| Host | Result | Build time | Closure | Warnings |")
    out.append("|---|---|---|---|---|")
    for h in hosts:
        res = "✅ passed" if h["passed"] else "❌ failed"
        out.append(f"| `{h['host']}` | {res} | {fmt_duration(h['duration'])} | {fmt_size(h['closure'])} | {len(h['warnings'])} |")
    out.append("")

    if failed:
        out.append("### Failures\n")
        for h in failed:
            out.append(details(f"❌ <code>{h['host']}</code>", h["error"], code=True))

    if any(h["warnings"] for h in hosts):
        out.append("### Warnings\n")
        for h in hosts:
            if h["warnings"]:
                out.append(details(f"<code>{h['host']}</code> ({len(h['warnings'])})", "\n\n".join(h["warnings"]), code=True))

    out.append("### Input changes\n")
    out.append(lock_diff(old_lock, new_lock))

    pkg_sections = [h for h in hosts if h["pkgs"]]
    if pkg_sections:
        out.append("### Package changes\n")
        for h in pkg_sections:
            out.append(details(f"<code>{h['host']}</code>", h["pkgs"]))

    body = "\n".join(out)
    if len(body) > BODY_LIMIT:
        body = body[:BODY_LIMIT] + f"\n\n_…truncated, see the [workflow run]({run_url}) summary._\n"
    return body, failed


def cmd_report(a):
    artifacts = Path(a.artifacts)
    hosts = [collect_host(artifacts, h) for h in a.hosts.split(",") if h]
    old_lock = load_json(artifacts / "lock" / "old.lock")
    new_lock = load_json(artifacts / "lock" / "flake.lock")
    body, failed = render(hosts, old_lock, new_lock, a.run_url, a.date)
    Path(a.out).write_text(body)

    failed_names = ",".join(h["host"] for h in failed)
    if failed:
        names = ", ".join(f"`{h['host']}`" for h in failed)
        banner = (
            f"{BANNER_START}\n> [!WARNING]\n"
            f"> **The latest update attempt ({a.date}) failed on {names}.** "
            f"This PR still holds the last lock that built on every host. "
            f"The failing lock is on branch `{a.fail_branch}` ([run]({a.run_url})).\n\n"
            + details("Report for the failed attempt", body[:25000])
            + f"{BANNER_END}\n"
        )
        Path(a.banner_out).write_text(banner)

    if gh_out := os.environ.get("GITHUB_OUTPUT"):
        with open(gh_out, "a") as f:
            f.write(f"all_passed={'false' if failed else 'true'}\n")
            f.write(f"failed={failed_names}\n")
            f.write(f"passed_count={len(hosts) - len(failed)}\n")
            f.write(f"total_count={len(hosts)}\n")


def cmd_banner(a):
    current = Path(a.current).read_text()
    banner = Path(a.banner).read_text()
    current = re.sub(re.escape(BANNER_START) + r".*?" + re.escape(BANNER_END) + r"\n*", "", current, flags=re.S)
    Path(a.out).write_text(banner + "\n" + current.lstrip())


def main():
    p = argparse.ArgumentParser()
    sub = p.add_subparsers(dest="cmd", required=True)

    r = sub.add_parser("report", help="render the PR body from build artifacts")
    r.add_argument("--artifacts", required=True)
    r.add_argument("--hosts", required=True, help="comma-separated")
    r.add_argument("--run-url", default="")
    r.add_argument("--date", default=dt.date.today().isoformat())
    r.add_argument("--fail-branch", default="auto/flake-update-failing")
    r.add_argument("--out", default="body.md")
    r.add_argument("--banner-out", default="banner.md")
    r.set_defaults(fn=cmd_report)

    b = sub.add_parser("banner", help="put a failure banner on top of an existing PR body")
    b.add_argument("--current", required=True)
    b.add_argument("--banner", required=True)
    b.add_argument("--out", required=True)
    b.set_defaults(fn=cmd_banner)

    a = p.parse_args()
    a.fn(a)


if __name__ == "__main__":
    main()
