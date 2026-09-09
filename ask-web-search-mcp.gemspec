# frozen_string_literal: true

require_relative "lib/ask/web_search/mcp/version"

Gem::Specification.new do |spec|
  spec.name = "ask-web-search-mcp"
  spec.version = Ask::WebSearch::MCP::VERSION
  spec.authors = ["Kaka Ruto"]
  spec.email = ["kaka@myrrlabs.com"]

  spec.summary = "MCP server for web search via SearXNG"
  spec.description = <<~DESC
    A minimal MCP (Model Context Protocol) server that exposes ask_web_search
    as a callable tool over stdio. Designed for use with clients that support MCP
    (ZCode, Claude Code, etc.), it queries a local SearXNG instance and returns
    formatted search results suitable for LLM consumption. The tool shell (name,
    schema, call) lives here, wrapping the Ask::WebSearch library.
  DESC

  spec.homepage = "https://github.com/ask-rb/ask-web-search-mcp"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir["lib/**/*", "LICENSE", "README.md", "CHANGELOG.md"]
  spec.bindir = "bin"
  spec.executables = ["ask-web-search-mcp"]
  spec.require_paths = ["lib"]

  # ask-mcp >= 0.4.3: the 0.4 line adds the stateless 2026-07-28 protocol
  # (server/discover negotiation, per-request _meta, MRTR) plus server-side
  # resources/prompts serving; 0.4.3 adds the serverInfo version passthrough
  # so this server can advertise its own gem version.
  spec.add_dependency "ask-mcp", ">= 0.4.6"
  # 0.3.0: the module-level library API (Ask::WebSearch.search); this
  # server owns the ask_web_search tool shell (duck-typed for the MCP
  # adapter), while the library's native Ask::Tools tool, when wanted,
  # is an optional integration in ask-web-search itself.
  # 0.4.0: retry with exponential backoff (3 attempts, configurable via
  # WebSearch.max_retries; set to 0 to disable).
  spec.add_dependency "ask-web-search", ">= 0.5.0"

  spec.add_development_dependency "minitest", "~> 5.25"
  spec.add_development_dependency "rake", "~> 13.0"
end
