# Dragon Dev Buddy profile

`config.json` records what this repo is, how exposed it is, what data it touches
and which trust boundaries exist. Security tooling reads it instead of asking
again every run. It is committed so the whole team shares one profile.

`reports/` is gitignored — audit output quotes real findings and real config.

## Why the scanner exists

This module mints IAM secret access keys and takes a GitHub App private key, an
OAuth client secret and the autoglue org secret as inputs. A committed profile is
visible to everyone with repo access, so a credential landing in it is a leak.

`scan-config.sh` (git plumbing) and `scan-config.py` (the detector) look for
credential-shaped values in `.dragon-buddy/*.json`: AWS access key ids, GitHub
tokens and PATs, PEM private keys, Slack tokens, JWTs, Vault tokens, and opaque
high-entropy values sitting under a key named like a secret.

```sh
./.dragon-buddy/scan-config.sh                 # scan staged content (hook mode)
./.dragon-buddy/scan-config.sh FILE...         # scan files on disk
```

Exit 0 clean, 1 on a finding, 2 on a usage or environment error.

## Enabling the pre-commit hook

Once per clone:

```sh
git config core.hooksPath .githooks
```

`.git/hooks/` is not shared by git, which is why the hook lives in the tracked
`.githooks/` directory instead. Setting `core.hooksPath` is per-clone config and
cannot be committed, so each person runs the line above.

Bypass a single commit with `git commit --no-verify`.

CI runs the same scanner on every pull request via
`.github/workflows/scan-buddy-profile.yml`, so an unenabled hook is not a hole.
