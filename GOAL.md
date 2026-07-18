# ask-web-search-mcp

## Purpose

A minimal MCP server that exposes the web search capability from
`ask-web-search` as a stdio-based tool, so that any MCP-compatible client
(ZCode, Claude Code, Codex) can use SearXNG for web searches without
needing to understand the ask-rb tool ecosystem.

## Dependencies

**Runtime:**
- `ask-mcp >= 0.1` — MCP server framework (stdio transport)
- `ask-web-search >= 0.2` — SearXNG-backed web search tool

**Development:**
- `minitest ~> 5.25`
- `rake ~> 13.0`

## Implementation

The gem is a thin wrapper:

```
bin/ask-web-search-mcp       → executable that starts the MCP server
lib/ask/web_search/mcp.rb    → module with .start method
lib/ask/web_search/mcp/version.rb → VERSION constant
```

It registers a single tool (`web_search`) and delegates execution to
`Ask::Tools::WebSearch`.

## What Done Means

- [x] Project scaffolded with standard ask-rb conventions
- [x] Gemspec, Gemfile, Rakefile in place
- [ ] Executable works: `bin/ask-web-search-mcp` starts and responds to MCP
      `tools/list` and `tools/call` over stdio
- [ ] Tests pass (gemspec validation, unit tests)
- [ ] Published to RubyGems
- [ ] Pushed to GitHub
- [ ] Documented in ask-docs
- [ ] Registered in ZCode config
