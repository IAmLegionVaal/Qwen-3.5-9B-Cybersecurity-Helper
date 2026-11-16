# FAQ

## Is 9B equal to 9 GB?

No. It refers to approximately 9 billion model parameters in the model family name. Quantization, runtime overhead and KV cache determine memory usage.

## Is Qwen3.5-9B uncensored?

Model behavior depends on the exact checkpoint/quantization, training and system prompt. Do not assume an official model or an unofficial variant will be accurate, safe or unfiltered.

## Will a Gemini MCP automatically give Bionic internet access?

No. A cloud model call is not the same as a web search or grounded retrieval. Live research requires a separate provider-supported grounding/search mechanism or a specifically configured web tool. Verify observed grounding in the response.

## What if the MCP server says connected but has no tools?

Inspect the real tool registry and errors. "Connected" only proves part of the transport path works.

## Why doesn't my imported skill install a PowerShell executor?

A skill is a text instruction; it does not add runtime tools by itself. The host must explicitly make an appropriately scoped shell tool available.

## Can the model damage hardware?

Normal model inference generally stresses CPU/GPU resources within system protections, but thermal limits, poor cooling and unstable drivers can affect reliability. Do not circumvent safeguards.

## Are private configuration files backed up by this repository?

No. This public project intentionally excludes secrets, app databases and private session state. Restoration requires separately retained local state and regenerated tokens.
