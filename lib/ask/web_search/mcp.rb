# frozen_string_literal: true

require "ask/mcp"
require "ask/web_search"
require_relative "mcp/tool"
require_relative "mcp/version"

module Ask
  module WebSearch
    module MCP
      # Builds the tool exposed over MCP. The tool framing lives here —
      # ask-web-search is a library (Ask::WebSearch.search); this server
      # owns the agent-facing shell, named "ask_web_search" to avoid
      # collisions with client-side tools of the same name.
      def self.tool
        Tool.new
      end

      # Start the MCP server over stdio, exposing the ask_web_search tool.
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
      #         "type": "stdio",
      #         "command": "ask-web-search-mcp",
      #         "args": []
      #       }
      #     }
      #   }
      def self.start
        Ask::MCP::Server.start_stdio(
          name: "ask-web-search-mcp",
          version: VERSION,
          tools: [tool],
          capabilities: { tools: {} },
          debug: ENV["DEBUG"] == "1"
        )
      end
    end
  end
end
