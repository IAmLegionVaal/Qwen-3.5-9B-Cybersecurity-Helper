# 08. Rebuild, recovery and ongoing maintenance

## Portable vs local-only state

**Portable:** Agent instructions, original SKILL.md files, generic example JSON, pinned external component references, runbooks, tests and script sources.

**Local-only:** Credentials, MCP auth/session tokens, actual endpoint URLs where sensitive, selected user folder paths, model weight files, application databases, chat history, incident logs, private model downloads and customer data.

Never mistake the public repository for a complete restorable image. Some Bionic settings may live in private application state and cannot be reconstructed from this template alone.

## Rebuild procedure

1. Record installed OS, GPU driver, Bionic/LM Studio version, supported local runtime and source model identifier.
2. Install Bionic and download the chosen supported Qwen3.5-9B quantization from a verified source.
3. Clone this repository into a new, non-sensitive folder.
4. Create a fresh Bionic project bound to a narrow workspace; load the agent prompt from agent/SYSTEM_PROMPT.md.
5. Import only the desired reviewed skills from skills/.
6. Recreate MCP server entries using Bionic's supported UI, with credentials obtained from the recipient's own secret store.
7. Test **each** MCP separately with one non-destructive command and an explicit permission inspection.
8. Run local API checks only if a separate compatible API server is enabled.
9. Run regression prompts against the chosen model with skills/tools disabled, then add them gradually.
10. Benchmark performance and record outcomes in a private sanitized inventory.

## Upgrade procedure

- Pin a known working model artifact and hashes before experimentation.
- Review release notes and third-party skill diffs before updating.
- Change one of: model, prompt, skill, MCP tool, or runtime per benchmark.
- Keep a rollback copy of **redacted** configurations and source code.
- Never synchronize raw app-state directories or caches into a public repository.

## Safe inventory export

~~~powershell
.\scripts\Export-SkillInventory.ps1 -SkillsRoot "$HOME\AgentSkills" -OutputPath "$HOME\Desktop\skill-inventory.json"
~~~

This script exports names and hashes, not the contents of SKILL.md, tokens or absolute user paths. **Review the output** before sharing; skill names may still reveal sensitive information. The output location is a local path and is not intended for GitHub.

## Maintenance cadence

Monthly: review model security advisories, dependency versions, broken reference URLs, skill quality and disk use. After an incident: rotate tokens, review MCP access and restore from trusted sources. On each PR: run validators and manually check the patch.
