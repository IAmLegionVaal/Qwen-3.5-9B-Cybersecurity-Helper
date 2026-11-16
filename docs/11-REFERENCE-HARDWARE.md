# Reference Lenovo LOQ hardware, model settings and safety

**Reference only.** These are observations and starting points from a particular Windows laptop, not minimum requirements, safe operating limits, benchmark guarantees or vendor recommendations. The exact CPU SKU, firmware, driver revision, cooling state, model file and exact Bionic build should be recorded independently for each reproducer.

## Hardware used in the example

| Item | Example |
| --- | --- |
| Laptop | Lenovo LOQ 15AHP10 |
| OS | Windows 11 |
| Processor | AMD Ryzen 7 (exact SKU not confirmed here) |
| Graphics | NVIDIA GeForce RTX 5060 Laptop, 8 GB dedicated VRAM |
| Memory | **16 GB RAM** during reference tests |
| SSD | 1 TB |
| AI runtime | LM Studio Bionic; local backend / model server |
| Model family | Qwen3.5-9B |
| Quantization | A Q4_K_M GGUF build was used in discussions; verify your actual file |
| Local API | One configured instance used http://localhost:1235/v1; LM Studio's separate API server often defaults to http://127.0.0.1:1234/v1 |

An earlier **loaded model instance** was reported as **qwen/qwen3.5-9b**, size approximately **6.55 GB**, **context 16384**, **parallel 1**. Other measurements reported about 5.66 GB for llama-server and 5565 / 8151 MiB dedicated GPU usage at one point. These are **snapshots**, not peak measurements or proof that all tools/skills worked flawlessly.

## Initial settings: cautious 16 GB RAM / 8 GB VRAM starting point

| Setting | Suggested initial value | Previously discussed/tuned values |
| --- | --- | --- |
| Context length | 8192 | 16384 observed in a loaded instance |
| Max concurrent requests | 1 | 1 was observed; earlier generic configs referenced 4 |
| GPU offload | Auto | Auto commonly selected |
| Flash Attention | On if supported | On reported |
| CPU threads | Runtime Auto | 6 discussed/tested previously |
| Eval batch | Auto (or smaller if OOM) | 2048 in an earlier model setup |
| Physical batch | Auto (or smaller if OOM) | 512 in an earlier model setup |
| Temperature | Start with official model's recommended regime | 0.8 in an earlier setup; lower values discussed for deterministic scripts |
| Reasoning budget | Start moderate | 8192 in an earlier unrelated model profile |
| KV cache to GPU | If supported and memory allows | On discussed |
| Quantization | Q4 for memory fit | Q4_K_M discussed |
| Repeat penalty | Default initially | 1.1 had been experimented with |

Do **not** copy the last column blindly. Some values were associated with an older Qwen 8B checkpoint or experimental configuration rather than the final Qwen3.5-9B build. Bionic versions and model backends may expose different controls.

## Capacity and performance guidance

- 8 GB VRAM does **not** mean 8 GB can be allocated without overhead. Windows rendering, model workspace and the KV cache consume memory.
- 16 GB system RAM limits simultaneous browser tabs, tools, model contexts and GPU fallback. Multiple concurrent jobs may cause substantial paging and stalls.
- Higher model parameter count is not the same as higher system quality. Quantization, instruction following, tool calling, architecture and prompt design matter.
- An 8 GB VRAM laptop may run a 9B 4-bit quantization reasonably but a 27B model will likely require substantial CPU/RAM offload or a remote host, with major latency trade-offs.
- PowerShell/Windows task quality must be judged using **tests**, not only tokens/sec or chat fluency.
- Tool availability and long-context workloads can impose more overhead than a simple local chat.

## Risk notice — PLEASE READ

This project includes configuration instructions and examples that can interact with the OS, websites and APIs. Incorrect configuration, insecure MCP permissions, untrusted skill installers, over-aggressive system tuning, privilege elevation or agent-generated commands can cause **data loss, application failure, service disruption, security compromise, financial costs or, in unusual circumstances, hardware stress**.

Running a supported LLM workload normally keeps CPU/GPU behavior under hardware/firmware thermal protections. **Do not disable fan controls, thermal protections, power limits or device safety mechanisms** to improve inference speed. Stop workloads if the system shows overheating, crashes, unsafe temperatures, unexpected reboots or hardware errors; investigate with vendor diagnostics.

**Before experimenting:**
1. Back up important files and ensure Windows recovery options work.
2. Keep the laptop on a well-ventilated firm surface and use an appropriate charger.
3. Follow the manufacturer’s thermal and power guidance; monitor Task Manager and NVIDIA/OS telemetry.
4. Start with one model and one concurrent request.
5. Avoid changing BIOS, GPU voltages, system protection policies or storage partitions on the model's advice.
6. Run agent commands as standard user; grant temporary elevation only after reviewing each command.
7. Never run unreviewed “security skills” or third-party MCP binaries with credentials or production access.
8. Record settings, measure resource changes and back off if instability appears.

**No warranty:** These examples are provided “as is” with no assurance of accuracy, fitness, security or performance for every machine. Operators are responsible for validating commands, authorizations, backups and change controls.

## Benchmark and safe change template

~~~text
Host RAM / VRAM:
OS / BIOS / GPU driver:
Bionic version:
Exact model filename, publisher, quantization and hash:
Context / offload / parallelism:
Skills enabled:
MCP enabled:
Prompt and expected result:
Elapsed time / tokens per second:
Peak RAM / dedicated VRAM / temperature:
Error logs (redacted):
Result: PASS / FAIL / NOT TESTED
Rollback configuration:
~~~
