# Changelog

## [0.1.0] - 2026-07-18

### Added

- Initial release — minimal MCP server exposing the `web_search` tool backed by
  SearXNG via `ask-web-search`.
- Stdio transport via `Ask::MCP::Server.start_stdio`.
- Configurable SearXNG URL via `SEARXNG_URL` environment variable (inherited
  from `ask-web-search`).
