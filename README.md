# ask-web-search-mcp

[![Gem Version](https://badge.fury.io/rb/ask-web-search-mcp.svg)](https://rubygems.org/gems/ask-web-search-mcp)

A minimal [MCP](https://modelcontextprotocol.io/) (Model Context Protocol) server
that exposes an `ask_web_search` tool backed by SearXNG. Designed for use with
MCP-compatible clients like **ZCode**, **Claude Code**, **Codex**, and others.

## Prerequisites

A running [SearXNG](https://docs.searxng.org/) instance. The default endpoint
is `http://localhost:8888`.

```sh
docker run -d --name searxng -p 8888:8080 searxng/searxng
```

Or use the provided `docker-compose.yml` in the [`searxng`](../searxng) directory:

```sh
cd searxng
docker compose up -d
```

You can customise the SearXNG URL via the `SEARXNG_URL` environment variable.

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

Add to your ZCode user configuration (`~/.zcode/v2/config.json` or `~/.zcode/cli/config.json`):

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

After restarting ZCode, the `ask_web_search` tool will be available
to the model automatically.

### With Claude Code

```sh
claude mcp add ask-web-search-mcp -- npx -y @anthropic-ai/mcp-serve ask-web-search-mcp
```

## Development

```sh
git clone https://github.com/ask-rb/ask-web-search-mcp
cd ask-web-search-mcp
bin/setup
bundle exec rake test
```

## License

MIT — see [LICENSE](LICENSE).
