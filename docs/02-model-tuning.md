# 02. Qwen3.5-9B model tuning

## What 9B means

B means **billions of model parameters**, not gigabytes of RAM or GPU memory. The official Qwen3.5-9B model card is the source of truth for architecture, original context capabilities and inference recipes. A quantized GGUF is a repackaging whose quality, RAM footprint and compatibility depend on the publisher and runtime.

The official model advertises very long context support; that **does not** mean a laptop can use the maximum context safely. Start modestly and measure memory, especially KV-cache and tool-message overhead.

## Suggested first baseline for constrained hardware

| Setting | Starting point | Revisit when |
| --- | --- | --- |
| Quantization | Compatible Q4_K_M or similarly sized GGUF if available | Quality or speed poor |
| Context | 4096–8192 tokens | Tasks genuinely require more |
| Concurrent generations | 1 | Memory headroom and stability proven |
| GPU offload | Auto / measured maximum | GPU OOM, fallback or poor speed |
| Flash Attention | Enabled if supported by runtime | Crashes or incompatibility |
| Temperature | 0.2–0.4 for troubleshooting/code | Creative tasks need diversity |
| Tool calls | Minimal tool selection | Agent repeats or wrong arguments |
| Reasoning budget | Modest, adjusted to model and harness | Endless thinking or truncation |

These are **proposed experiment settings**, not claimed defaults or a verified best configuration. Some controls may be unavailable in a given Bionic build. A lower temperature can reduce randomness but cannot fix missing knowledge, broken tool schemas or poor model capability.

## Quantization decision

- Q4 generally needs less RAM and may lose some accuracy compared to larger formats.
- Q5/Q6 may improve fidelity at the cost of loading and VRAM capacity.
- If GPU memory is saturated, partial CPU offload may make inference slower rather than simply "better".
- An 8-bit or 16-bit build often will not fit entirely in an 8 GB GPU for a model of this scale.
- Avoid using multiple large models concurrently on 16 GB system RAM.

## Benchmark protocol

1. Record exact model identifier, file hash, runtime and driver versions.
2. Cold-start model; capture idle RAM/VRAM.
3. Test the regression prompts in agent/REGRESSION_PROMPTS.md.
4. Measure time to first token, generation speed, peak memory and instruction/tool correctness.
5. Increase context by one increment only if the baseline is stable.
6. Compare a second model with the **same prompts and tool permissions**.
7. Save anonymized test results, not private input/output.

## Why the agent repeats or gets facts wrong

Common causes: overlong/conflicting system prompts, poor few-shot examples, thinking tokens consuming context, excessive skill injection, tool schemas too large, missing retrieval/grounding, bad stop tokens and undersized model capability. The preferred response is a shorter focused prompt, one relevant skill, smaller tool inventory and independent verification. No prompt can guarantee a model will not hallucinate.

## Hardware safety

Sustained inference typically increases utilization, heat and fan activity. Use manufacturer-approved thermal limits, monitor temperature and never disable protection mechanisms to gain speed. High memory pressure can cause paging and stalls; model load failures are usually resource/configuration problems, not evidence of physical damage.

Official model card: https://huggingface.co/Qwen/Qwen3.5-9B
