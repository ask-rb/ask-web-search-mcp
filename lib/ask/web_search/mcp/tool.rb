# frozen_string_literal: true

require "ask/web_search"

module Ask
  module WebSearch
    module MCP
      # The ask_web_search tool, duck-typed for Ask::MCP's ToolServer
      # adapter (name / description / params_schema / call). The tool
      # framing lives with its consumer — this server — not in the
      # library: the capability is Ask::WebSearch.search, this is the
      # agent-facing shell around it.
      class Tool
        def name
          "ask_web_search"
        end

        def description
          "Search the web for current information. Use this to get up-to-date results, recent events, or facts that may have changed."
        end

        def params_schema
          {
            "type" => "object",
            "properties" => {
              "query" => { "type" => "string", "description" => "The search query" },
              "time_range" => {
                "type" => "string",
                "enum" => Ask::WebSearch::TIME_RANGES,
                "description" => "Freshness window: only results from the past day, week, month, or year. Use for recency-sensitive queries (news, prices, releases); omit otherwise."
              },
              "categories" => {
                "type" => "string",
                "enum" => %w[general news science],
                "description" => "Vertical to search: general web results (default), news, or science (research papers). Use news for current events, science for papers."
              }
            },
            "required" => ["query"]
          }
        end

        # Returns the formatted results (a String is a success for the
        # adapter). On failure, returns a formatted error string so the
        # agent gets the library's diagnostics instead of a generic
        # transport error — including the library's ArgumentError for a
        # bad time_range, which tells the agent which values are valid.
        def call(args)
          query = args["query"].to_s
          raise ArgumentError, "missing required parameter: query" if query.empty?

          Ask::WebSearch.search(query, time_range: args["time_range"], categories: args["categories"])
        rescue StandardError => e
          "Error: #{e.class.name}: #{e.message}"
        end
      end
    end
  end
end
