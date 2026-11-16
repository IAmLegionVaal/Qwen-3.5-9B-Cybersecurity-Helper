# Architecture

~~~text
         +-------------------------+
         | User / Bionic project   |
         +-------------------------+
                      |
          instructions and scope
                      v
         +-------------------------+
         | Harness: LM Studio      |
         | Bionic                  |
         +-------------------------+
             |               |
   skills (text)       MCP tools (code)
             |               |
             v               v
       SKILL.md        constrained services
             |          local or remote
             |               |
             +-------+-------+
                     |
              chosen model
                     |
          Qwen3.5-9B local
                     |
           verified response
                     |
         optional PUBLIC-only
          cloud escalation
          after explicit OK
~~~

**Trust boundaries:** User instructions != external web content. Skills are instructions, not permission grants. MCP servers are code with OS and network permissions. API keys exist in the runtime's secret store, never in a public config. A remote model is another data processor and is not a drop-in replacement for internet grounding.
