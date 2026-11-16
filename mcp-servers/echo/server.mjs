#!/usr/bin/env node
/**
 * Minimal, offline MCP stdio server for safe protocol diagnostics.
 * No external dependencies, file reads, network calls or credential handling.
 * One JSON-RPC 2.0 message per line; output is protocol messages only.
 * Node 20+ recommended. Reference demo, not a production MCP broker.
 */
import readline from "node:readline";

const SERVER_NAME = "qwen-local-echo-demo";
const SUPPORTED_VERSIONS = new Set(["2025-06-18", "2025-11-25", "2026-07-28"]);
const DEFAULT_VERSION = "2025-06-18";
const MAX_LINE_LENGTH = 16384;
const MAX_ECHO_LENGTH = 512;

function send(payload) {
  process.stdout.write(JSON.stringify(payload) + "\n");
}

function errorResponse(id, code, message) {
  send({ jsonrpc: "2.0", id, error: { code, message } });
}

function handle(request) {
  if (!request || typeof request !== "object" || Array.isArray(request) ||
      request.jsonrpc !== "2.0" || typeof request.method !== "string") {
    errorResponse(request?.id ?? null, -32600, "Invalid Request");
    return;
  }
  const hasId = Object.hasOwn(request, "id");
  const id = hasId ? request.id : null;
  // MCP initialization completion and other notifications expect no reply.
  if (!hasId) return;
  if (typeof id !== "string" && typeof id !== "number") {
    errorResponse(null, -32600, "Invalid request id");
    return;
  }

  switch (request.method) {
    case "initialize": {
      const requested = request.params?.protocolVersion;
      const protocolVersion = SUPPORTED_VERSIONS.has(requested)
        ? requested : DEFAULT_VERSION;
      send({
        jsonrpc: "2.0", id,
        result: {
          protocolVersion,
          capabilities: { tools: { listChanged: false } },
          serverInfo: { name: SERVER_NAME, version: "1.0.0" },
        },
      });
      break;
    }
    case "ping":
      send({ jsonrpc: "2.0", id, result: {} });
      break;
    case "tools/list":
      send({
        jsonrpc: "2.0", id,
        result: {
          tools: [{
            name: "echo",
            description: "Returns a short non-sensitive string unchanged. No files, shell or network.",
            inputSchema: {
              type: "object",
              properties: {
                text: { type: "string", maxLength: MAX_ECHO_LENGTH },
              },
              required: ["text"],
              additionalProperties: false,
            },
          }],
        },
      });
      break;
    case "tools/call": {
      const params = request.params ?? {};
      if (params.name !== "echo") {
        errorResponse(id, -32602, "Unknown tool");
        break;
      }
      const args = params.arguments;
      if (!args || typeof args !== "object" || Array.isArray(args) ||
          Object.keys(args).some((k) => k !== "text") ||
          typeof args.text !== "string" || args.text.length > MAX_ECHO_LENGTH) {
        errorResponse(id, -32602, "echo expects a text string of up to 512 characters");
        break;
      }
      send({
        jsonrpc: "2.0", id,
        result: { content: [{ type: "text", text: args.text }], isError: false },
      });
      break;
    }
    default:
      errorResponse(id, -32601, "Method not found");
  }
}

const reader = readline.createInterface({ input: process.stdin, crlfDelay: Infinity });
reader.on("line", (line) => {
  if (line.length > MAX_LINE_LENGTH) {
    errorResponse(null, -32700, "Message exceeds limit");
    return;
  }
  try {
    handle(JSON.parse(line));
  } catch (_error) {
    errorResponse(null, -32700, "Parse error");
  }
});
reader.on("close", () => { process.exitCode = 0; });
