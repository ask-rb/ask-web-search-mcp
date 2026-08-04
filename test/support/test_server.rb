#!/usr/bin/env ruby
# frozen_string_literal: true

# Spawned as a subprocess by the integration tests. BUNDLE_GEMFILE is set to
# this gem's Gemfile (which resolves ask-mcp from the local path), so the
# server exercises the current protocol support rather than the published gem.

require "bundler/setup"
$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "ask/web_search/mcp"

Ask::WebSearch::MCP.start
