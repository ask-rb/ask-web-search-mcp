# frozen_string_literal: true

require_relative "lib/ask/web_search/mcp/version"

Gem::Specification.new do |spec|
  spec.name = "ask-web-search-mcp"
  spec.version = Ask::WebSearch::MCP::VERSION
  spec.authors = ["Kaka Ruto"]
  spec.email = ["kaka@myrrlabs.com"]

  spec.summary = "MCP server for web search via SearXNG"
  spec.description = <<~DESC
    A minimal MCP (Model Context Protocol) server that exposes Ask::Tools::WebSearch
    as a callable tool over stdio. Designed for use with clients that support MCP
    (ZCode, Claude Code, etc.), it queries a local SearXNG instance and returns
    formatted search results suitable for LLM consumption.
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

  spec.add_dependency "ask-mcp", ">= 0.1"
  spec.add_dependency "ask-web-search", ">= 0.2"

  spec.add_development_dependency "minitest", "~> 5.25"
  spec.add_development_dependency "rake", "~> 13.0"
end
