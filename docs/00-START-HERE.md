# Full setup walkthrough: Qwen 3.5 9B Cybersecurity Helper

This guide starts from a clean Windows machine and ends with a **tested** Bionic agent using a local Qwen3.5-9B model, reusable Agent Skills, and optional PowerShell, GitHub, WordPress and Gemini connections. It distinguishes **confirmed observations from the reference workstation** from **recommended settings and unverified integrations**.

**Important:** Misconfiguration can cause crashes, overheating, loss of unsaved data, accidental file deletion, security exposure or unauthorized changes when automation is given too much access. Normal model inference, with manufacturer thermal and power protections functioning, should not itself physically damage a healthy computer. Nevertheless, **use at your own risk**, monitor temperatures and resource usage, keep backups, and never disable safety protections to obtain more performance. Your results will vary by hardware, drivers, quantization, settings and workload. See [Hardware, safety & performance](11-REFERENCE-HARDWARE.md).

## Stage 1 — Confirm the hardware and create a safe workspace

The reference example is a **Lenovo LOQ 15AHP10, AMD Ryzen 7, RTX 5060 Laptop 8 GB VRAM, 16 GB system RAM, 1 TB SSD, Windows 11**. These are example hardware specifications, not requirements or a guarantee that your own device can use the same settings.

Run in PowerShell (read-only):

~~~powershell
Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer,Model,TotalPhysicalMemory
Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber
Get-Command git,python,node,npm.cmd,npx.cmd -ErrorAction SilentlyContinue | Select-Object Name,Source
nvidia-smi  # NVIDIA GPU driver utility, if installed
~~~

Use a dedicated workspace, e.g. **C:\AI\Workspace**. Do not give Bionic blanket access to C:\, an entire user profile, customer shares or production credentials. Prefer a standard (non-administrator) Windows account.

**Pass condition:** Sufficient memory/disk, working graphics driver, a clear workspace boundary, and no sensitive files under the agent's general coding directory.

## Stage 2 — Install the runtime and model

1. Read [Bionic's official documentation](https://lmstudio.ai/docs/bionic). Install Bionic from its official source. Bionic is a separate application from the classic LM Studio desktop app.
2. Use the local model picker. Obtain a supported **Qwen3.5-9B** quantization from a verified publisher/model card; verify the file name and license. Start with a compatible 4-bit GGUF if your runtime supports it.
3. Create a Bionic project pointing at the restricted workspace.
4. Load the model **without** adding skills or MCP tools first.
5. Ask a simple deterministic question to confirm the model produces a complete response.
6. Record model identifier, quantization, selected context, offload, runtime version, and baseline VRAM/RAM.

For a new 8 GB VRAM / 16 GB RAM build, start with **8192 context, one concurrent request, automatic GPU offload and Flash Attention only if supported**. The recorded workstation had a successful loaded instance at **16384 context and parallel 1** with a 6.55 GB model. Do not immediately copy every recorded setting without benchmarking.

Read [Reference hardware and settings](11-REFERENCE-HARDWARE.md) and [Model tuning](02-model-tuning.md).

**Pass condition:** Stable response without endless repetition, crash or resource exhaustion.

## Stage 3 — Add the system prompt

Copy [Complete reusable agent prompt](../agent/SYSTEM_PROMPT-COMPLETE.md) into your Bionic agent custom instructions. It is an **original public-safe reconstruction of the approach** used for technical support and cybersecurity; it is **not a byte-for-byte export** of anyone's personal prompt.

The prompt covers: L3 infrastructure diagnosis, defensive security research, AD, M365/Entra/Intune, Windows and network diagnostics, production-quality PowerShell, C#/type safety, honest tool handling, prompt-injection defense, no repetitive output, source verification and optional explicitly approved external assistance.

Use either the complete prompt or the short [baseline prompt](../agent/SYSTEM_PROMPT.md); **do not stack multiple overlapping prompts** without testing.

**Pass condition:** Agent follows instructions without reciting them, inventing tools, or looping. Test with [Regression prompts](../agent/REGRESSION_PROMPTS.md).

## Stage 4 — Install Agent Skills

1. Download this repository using GitHub **Code → Download ZIP**, or clone it via Git.
2. Review the files in [skills/](../skills/) and read [Skill catalog](12-SKILL-CATALOG.md).
3. Validate the structure locally using the Python checks from the repository.
4. In Bionic go to **Settings → Skills**. Import a selected SKILL.md, or ask the host to install a skill from its reviewed GitHub URL. The official Skills workflow also supports @ references in chat.
5. Import **one skill at a time** and test it before adding another.
6. Remember that **Agent Skills are instructions, not tools**. A PowerShell skill does not install a shell executor or authorize arbitrary commands.

The ten original skills currently in this repository are **not an export of the original workstation**. To include exact local skills, use [Exact installed skill export](13-EXACT-SKILL-EXPORT.md). Do not mistake a similarly named recreated skill for an identical local copy.

**Pass condition:** Bionic selects the intended SKILL.md with @; a safe request follows that skill's workflow.

## Stage 5 — Enable local tooling, cautiously

A previous PowerShell setup exposed tools named **powershell_validate**, **powershell_readonly**, and **shell_command**, plus read/edit file tools. These came from the host or extra MCP tooling, **not** from Qwen or SKILL.md itself.

Start with a tool that only checks syntax or prints non-sensitive environment metadata. **Do not** allow arbitrary privileged system commands, remote script execution or production writes by default.

One reproduced failure: **powershell_readonly** expected a string argument such as check="environment"; an attempt to pass a boolean caused a schema error. Check actual tool schemas shown by Bionic, rather than guessing JSON.

**Pass condition:** Advertised tool is present, a harmless call returns an actual host result, and invalid arguments fail clearly.

## Stage 6 — Add MCP connections individually

See the detailed [Connection recipes](14-CONNECTION-RECIPES.md).

- **GitHub MCP:** authenticate with minimal scope; test read-only repository listings before enabling writes.
- **WordPress MCP:** use a sandbox site and dedicated least-privileged account; verify tool discovery, then site inspection and plugin audit. Do not publish the actual domain or credentials.
- **Gemini advisory bridge:** optional Node.js MCP for a second opinion on eligible public/sanitized prompts. Confirm timeout, successful response, model ID and whether any live search grounding was **actually** enabled.
- **Safe PowerShell MCP:** validation and read-only diagnostics first, command execution only after narrow explicit approval.

Do not enable every connector together on day one. Tool schemas and responses consume context tokens and may worsen reliability on smaller models.

**Pass condition:** Each connector completes one independently verified harmless call. “Connected” alone is not acceptance.

## Stage 7 — Validate internet research and privacy

Local Qwen has **no automatic internet knowledge**. A connected cloud LLM can answer a prompt but does **not** automatically search the live web. Search/grounding requires an actual retrieval-enabled tool and evidence. Treat remote providers as separate data processors; **never send private tickets, credentials, logs or customer data without approved classification and consent**.

**Pass condition:** The model cites verifiable sources when real search is used and explicitly labels claims unverified otherwise.

## Stage 8 — Measure performance and run regression suite

For each configuration:

1. Verify actual model ID and tool list.
2. Run [ten regression prompts](../agent/REGRESSION_PROMPTS.md) with no tools.
3. Run again with one skill selected.
4. Test one MCP at a time.
5. Monitor RAM/VRAM, paging, temperature, first-token latency, task success and failures.
6. Make **one change at a time** and compare results.
7. Keep a rollback path: prior model quantization, previous settings, no-MCP baseline and backups.

**Pass condition:** Reliable PowerShell syntax, honest tool outcomes, no secret leakage, bounded retries, stable memory use and no unexplained changes to system state.

## Download and reproduce

GitHub's **Code → Download ZIP** gives users the public reference kit. The original workstation skills, including any supporting scripts and references, require a separately reviewed exact export before they can be published for direct download. A ZIP of unknown local files is **not safe to release automatically**.

## Help and maintenance

- [Common problems](07-troubleshooting.md)
- [Security and secret handling](06-security-and-secrets.md)
- [External skill review queue](09-third-party-skills.md)
- [Restoration](08-rebuild-and-maintenance.md)
- [Validation](10-validation.md)


## Cybersecurity specialization

Once the base model, agent prompt and offline MCP demo work reliably, choose from **32 downloadable SKILL.md workflows**. Begin with the [authorized security and pentest skill catalog](15-CYBERSECURITY-SKILL-PATHS.md). Select one skill per task before adding tools, and check Rules of Engagement before any active assessment. Hardware and performance limitations still apply.
