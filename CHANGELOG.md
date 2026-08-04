# Changelog

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
