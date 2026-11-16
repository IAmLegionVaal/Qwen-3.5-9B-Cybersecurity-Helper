# Publishing the exact Bionic skill bundle safely

## Current status

The reference machine's complete installed skill tree has **not yet been copied** to this public repository. The included skills are useful authored examples but are NOT the complete original workstation installation.

## Known source details

One previously verified local skill path resembled:

~~~text
%USERPROFILE%\.lmstudio\skills\powershell-expert\
~~~

The known files were SKILL.md, references/CATALOG.md, references/powershell-expert.md and scripts/Search-Gallery.ps1. Bionic can also expose compatible skills from other applications. Inspect **Settings → Skills → Use skills found in other apps** to discover those locations.

## Inventory on your own Windows computer

~~~powershell
$SkillsRoot = Join-Path $HOME '.lmstudio\skills'
Get-ChildItem -LiteralPath $SkillsRoot -Directory -ErrorAction Stop | Select-Object Name
.\scripts\Export-SkillInventory.ps1 -SkillsRoot $SkillsRoot -OutputPath "$HOME\Desktop\skill-inventory.json"
~~~

Review the report for sensitive skill names before sharing.

## Create a local private review copy

The **Export-ExactBionicSkills.ps1** script preserves file bytes and relative paths, produces SHA256 hashes and a review report, and refuses to follow symlinks or overwrite existing output. It DOES NOT upload anything, publish to GitHub, install dependencies, run a skill or create a distributable ZIP.

~~~powershell
.\scripts\Export-ExactBionicSkills.ps1 -SourceRoot "$HOME\.lmstudio\skills" -OutputDirectory "$HOME\Documents\BionicSkills-PrivateReview" -WhatIf
.\scripts\Export-ExactBionicSkills.ps1 -SourceRoot "$HOME\.lmstudio\skills" -OutputDirectory "$HOME\Documents\BionicSkills-PrivateReview"
~~~

Keep the review folder PRIVATE, not in Git or a cloud-synced directory.

## Mandatory publication checklist

1. Inspect every SKILL.md plus scripts, references, assets and dependency manifests.
2. Verify exact upstream origin and license for each third-party component. MIT licensing of this repository does not override other licenses.
3. Check private names, domains, customer data, tokens and credentials in **filenames and contents**.
4. Audit scripts for remote downloads, shell execution, encoded code, install hooks, dependencies and persistence.
5. Run tests only in a disposable low-privilege environment without real secrets.
6. Publish only a reviewed, licensed bundle under verified-installed-skills/, including provenance and SHA256 checksums.
7. If you redact or edit anything, explicitly label it **modified**, not exact.
8. Download the public copy into a clean installation and test Bionic imports and functionality.
9. Optionally make a GitHub Release ZIP of **only** approved public files.

A clean scanner result does **not** prove there are no secrets. This procedure requires human review.

## Confidentiality rules

Never upload the whole .lmstudio user profile, application databases, chat history, live MCP JSON, environment dumps, GitHub PATs, WordPress accounts, cloud provider tokens or production incident material.

If a secret was ever published, revoke/rotate it; deleting a current file is insufficient to erase Git history.

Until this workflow is completed, do not advertise the reference workstation's complete exact skill bundle as downloadable.
