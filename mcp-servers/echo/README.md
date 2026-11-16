# Local echo MCP demo

This is a **dependency-free, network-free** MCP stdio test server. It does not use credentials, read/write files, run commands or contact a model API. It helps beginners separate a Bionic/MCP protocol issue from a network/authentication problem.

## Run

~~~powershell
node --check .\mcp-servers\echo\server.mjs
node .\mcp-servers\echo\server.mjs
~~~

In Bionic Settings > MCP, create a **local stdio** server using Node and an absolute path to this server.mjs. Ask the agent to list available tools. It should see an **echo** tool with one required string argument **text**.

Then ask Bionic to invoke echo with a harmless dummy value such as "hello". The tool should return exactly that text. Do **not** send secrets, customer data or real log contents.

Run the automated Node test if available:

~~~powershell
node .\mcp-servers\echo\test.mjs
~~~

If you do not have a tool listed, inspect whether Bionic actually launched the process, whether the path is valid and what protocol errors are shown. A visible connection entry alone is not a successful tool call.

## Scope

Not production hardened. It is a teaching example that intentionally lacks authorization, authentication and network transport because it has **no privileged actions**. Do not add shell or filesystem functionality to this demo without a separate security review.
