#!/usr/bin/env node
/** Offline process-level smoke test for the demo MCP stdio server. */
import { spawn } from "node:child_process";
import readline from "node:readline";
import { strict as assert } from "node:assert";
import { fileURLToPath } from "node:url";

const child = spawn(process.execPath, [fileURLToPath(new URL("./server.mjs", import.meta.url))], {
  stdio: ["pipe", "pipe", "pipe"],
  windowsHide: true,
});
const lines = readline.createInterface({ input: child.stdout });
let settled = false;

function finish(error) {
  if (settled) return;
  settled = true;
  lines.close();
  child.kill();
  if (error) {
    process.stderr.write(error.message + "\n");
    process.exitCode = 1;
  } else {
    process.stdout.write("MCP demo server smoke test passed.\n");
  }
}

function writeRequest(id, method, params = {}) {
  child.stdin.write(JSON.stringify({ jsonrpc: "2.0", id, method, params }) + "\n");
}
lines.on("line", (line) => {
  try {
    const response = JSON.parse(line);
    if (response.id === 1) {
      assert.equal(response.result.serverInfo.name, "qwen-local-echo-demo");
      writeRequest(2, "tools/list");
    } else if (response.id === 2) {
      assert.equal(response.result.tools[0].name, "echo");
      writeRequest(3, "tools/call", { name: "echo", arguments: { text: "hello" } });
    } else if (response.id === 3) {
      assert.equal(response.result.content[0].text, "hello");
      finish();
    }
  } catch (error) {
    finish(error);
  }
});
child.on("error", finish);
child.on("exit", (code) => {
  if (!settled) finish(new Error("Server exited before completing smoke test: " + code));
});
const timeout = setTimeout(() => {
  finish(new Error("MCP smoke test timed out"));
}, 5000);
timeout.unref();
writeRequest(1, "initialize", { protocolVersion: "2025-06-18", capabilities: {}, clientInfo: { name: "demo-test", version: "1" } });
