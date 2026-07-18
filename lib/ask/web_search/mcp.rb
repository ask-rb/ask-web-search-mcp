# frozen_string_literal: true

require "ask/mcp"
require "ask/web_search"
require_relative "mcp/version"

module Ask
  module WebSearch
    module MCP
      # Start the MCP server over stdio, exposing the WebSearch tool.
      #
      #   $ ask-web-search-mcp
      #
      # The server will listen for JSON-RPC messages on stdin and write
      # responses to stdout — the standard MCP stdio transport.  Register
      # this executable as an MCP server in your client configuration:
      #
      #   "mcp": {
      #     "servers": {
      #       "ask-web-search-mcp": {
      #         "command": "ask-web-search-mcp",
      #         "type": "stdio"
      #       }
      #     }
      #   }
      def self.start
        Ask::MCP::Server.start_stdio(
          name: "ask-web-search-mcp",
          tools: [Ask::Tools::WebSearch.new],
          capabilities: { tools: {} },
          debug: ENV["DEBUG"] == "1"
        )
      end
    end
  end
end
