# Changelog

## [0.4.5] — 2026-09-09

### Changed

- Depends on `ask-web-search >= 0.5.0` for engine failure diagnostics
  (`AllEnginesFailedError` with per-engine reasons) and retry with
  exponential backoff.

## [0.4.0] - 2026-08-12

### Changed

- **The server owns its tool shell.** `ask_web_search` is now a
  duck-typed tool (`Ask::WebSearch::MCP::Tool` — `name` /
  `description` / `params_schema` / `call`) wrapping the library entry
  `Ask::WebSearch.search`, instead of a renamed `Ask::Tools::WebSearch`.
  The MCP adapter's contract is duck-typed by design, so the ask-tools /
  ask-core / ask-schema dependency chain is gone from the server
  process entirely. `ask-web-search` floor raised to `>= 0.3.0` (the
  module-level API). The native agent tool remains available in
  ask-web-search as an optional integration for non-MCP consumers.

## [0.3.1] - 2026-08-04

### Fixed

- Corrected publish of the 0.3.0 changeset (0.3.0 was yanked — it shipped a
  stale build missing the `tool` extraction and serverInfo version
  passthrough). 0.3.1 is the same changeset built correctly.

## [0.3.0] - 2026-08-04

### Changed

- **Stateless protocol support (2026-07-28)** — the server now negotiates the
  stateless MCP revision via `server/discover` (no `initialize` handshake,
  per-request `_meta`, `resultType`) when the client supports it, while
  remaining backward compatible with legacy `initialize`-handshake clients.
  Requires `ask-mcp >= 0.4` — the 0.4 line also brings server-side
  resources/prompts and the Streamable HTTP rework.
- Development resolves `ask-mcp` from rubygems via the `>= 0.4` floor — no
  local path overrides; the server always exercises the published protocol
  support.

### Added

- Functional test suite (`test/server_test.rb`) driving the server end-to-end
  with `Ask::MCP::Client` over a real stdio subprocess: stateless
  negotiation, tool listing, tool calls against a stubbed SearXNG (in-process
  `FakeSearxng`), no-results handling, unknown-tool errors, and a
  SearXNG-unreachable error path.
- `Ask::WebSearch::MCP.tool` — extracted, testable accessor for the
  `ask_web_search` tool instance, with unit tests covering the MCP tool
  contract (name, description, params schema).
- The server now reports its own gem version in the MCP `serverInfo`
  handshake (via `ask-mcp >= 0.4.3`), instead of ask-mcp's version.

## [0.2.0] - 2026-07-18

### Changed

- Renamed tool from `web_search` to `ask_web_search` to avoid collision with
  built-in client tools. (#diff-name)

## [0.1.0] - 2026-07-18

### Added

- Initial release — minimal MCP server exposing the `web_search` tool backed by
  SearXNG via `ask-web-search`.
- Stdio transport via `Ask::MCP::Server.start_stdio`.
- Configurable SearXNG URL via `SEARXNG_URL` environment variable (inherited
  from `ask-web-search`).
