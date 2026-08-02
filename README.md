# ask-web-search-mcp

[![Gem Version](https://badge.fury.io/rb/ask-web-search-mcp.svg)](https://rubygems.org/gems/ask-web-search-mcp)

A minimal [MCP](https://modelcontextprotocol.io/) (Model Context Protocol)
server that exposes an `ask_web_search` tool backed by SearXNG. Designed for
use with MCP-compatible clients like ZCode, Claude Code, Codex, and others.

The tool was renamed from `web_search` to `ask_web_search` in version 0.2.0 to
avoid collisions with client-side tools. Use `ask_web_search` in your
configuration and prompts.

## Prerequisites

A running [SearXNG](https://docs.searxng.org/) instance. The default endpoint
is `http://localhost:8888`.

```sh
docker run -d --name searxng -p 8888:8080 searxng/searxng
```

Or use the provided `docker-compose.yml` in the `searxng` directory of this
repository:

```sh
cd searxng
docker compose up -d
```

## Installation

```sh
gem install ask-web-search-mcp
```

Or in your Gemfile:

```ruby
gem "ask-web-search-mcp"
```

## Usage

### Standalone

```sh
ask-web-search-mcp
```

The server reads JSON-RPC messages on stdin and writes responses to stdout
(the standard MCP stdio transport).

### With ZCode

Add to your ZCode user configuration (`~/.zcode/v2/config.json` or
`~/.zcode/cli/config.json`):

```json
{
  "mcp": {
    "servers": {
      "ask-web-search-mcp": {
        "type": "stdio",
        "command": "ask-web-search-mcp",
        "args": []
      }
    }
  }
}
```

After restarting ZCode, the `ask_web_search` tool will be available to the
model automatically.

### With Claude Code

```sh
claude mcp add ask-web-search-mcp -- npx -y @anthropic-ai/mcp-serve ask-web-search-mcp
```

## Configuration

- `SEARXNG_URL` - the SearXNG endpoint (default: `http://localhost:8888`).
- `DEBUG=1` - enable verbose logs on stderr.

## Full documentation

The full ask-rb documentation lives at https://ask-rb.github.io/ask-docs.
[Core: Web Search](https://ask-rb.github.io/ask-docs/core/web-search) covers
ask-web-search-mcp in depth, including the tool library and troubleshooting.
API reference: https://ask-rb.github.io/ask-docs/reference/api.

## Development

```
bundle install
bundle exec rake test
```

## License

MIT
