#!/usr/bin/env python3
"""Detect credential-shaped values in a buddy profile. Reads JSON on stdin.

Usage: scan-config.py LABEL  <  content.json
Exit 0 clean, 1 on a finding or invalid JSON.
"""
import json
import re
import sys

PATTERNS = [
    (re.compile(r"\b(?:AKIA|ASIA|ABIA|ACCA)[0-9A-Z]{16}\b"), "AWS access key id"),
    (re.compile(r"\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{36,}\b"), "GitHub token"),
    (re.compile(r"\bgithub_pat_[A-Za-z0-9_]{22,}\b"), "GitHub fine-grained PAT"),
    (re.compile(r"-----BEGIN (?:[A-Z ]+ )?PRIVATE KEY-----"), "PEM private key"),
    (re.compile(r"\bxox[abposr]-[A-Za-z0-9-]{10,}\b"), "Slack token"),
    (re.compile(r"\bsk-[A-Za-z0-9]{32,}\b"), "API secret key"),
    (re.compile(r"\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b"), "JWT"),
    (re.compile(r"\bhvs\.[A-Za-z0-9_-]{20,}\b"), "Vault token"),
]

# Key names whose value should never be a literal credential.
SECRET_KEY = re.compile(
    r"(secret|token|password|passwd|credential|private_key|api_key|access_key|_key$|^key$)",
    re.I,
)
# Credential-shaped: no whitespace and long. Prose and identifiers are excluded below.
OPAQUE = re.compile(r"^[A-Za-z0-9+/=_.:-]{20,}$")
# Ordinary lowercase identifiers and paths: renovate, github-secret-scanning, .dragon-buddy/reports
IDENTIFIER = re.compile(r"^[a-z0-9]+(?:[-_./][a-z0-9]+)*$")


def walk(node, path, findings):
    if isinstance(node, dict):
        for k, v in node.items():
            walk(v, f"{path}.{k}" if path else k, findings)
    elif isinstance(node, list):
        for i, v in enumerate(node):
            walk(v, f"{path}[{i}]", findings)
    elif isinstance(node, str):
        for pat, what in PATTERNS:
            if pat.search(node):
                findings.append((path or "<root>", what))
                return
        leaf = path.split(".")[-1].split("[")[0]
        if SECRET_KEY.search(leaf) and OPAQUE.match(node) and not IDENTIFIER.match(node):
            findings.append((path, "credential-shaped value under a secret-named key"))


def main():
    label = sys.argv[1] if len(sys.argv) > 1 else "<stdin>"
    raw = sys.stdin.read()
    if not raw.strip():
        print(f"  {label}: empty document, nothing scanned", file=sys.stderr)
        return 1

    try:
        doc = json.loads(raw)
    except json.JSONDecodeError as e:
        print(f"  {label}: invalid JSON ({e})", file=sys.stderr)
        return 1

    findings = []
    walk(doc, "", findings)

    # Catch secrets sitting inside prose values, not just under secret-named keys.
    seen = {what for _, what in findings}
    for pat, what in PATTERNS:
        if what not in seen and pat.search(raw):
            findings.append(("<document>", what))

    for path, what in findings:
        print(f"  {label}: {what} at {path}", file=sys.stderr)
    return 1 if findings else 0


if __name__ == "__main__":
    sys.exit(main())
