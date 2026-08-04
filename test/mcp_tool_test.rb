# frozen_string_literal: true

require_relative "test_helper"

# Unit tests for the tool wiring, without spawning the stdio server.
class MCPToolTest < Minitest::Test
  def setup
    @tool = Ask::WebSearch::MCP.tool
  end

  def test_exposes_the_tool_under_the_ask_web_search_name
    assert_equal "ask_web_search", @tool.name
    assert_kind_of Ask::Tools::WebSearch, @tool
  end

  def test_satisfies_the_duck_typed_mcp_tool_contract
    refute_empty @tool.description
    assert_includes @tool.params_schema["required"], "query"
    assert_equal "string", @tool.params_schema.dig("properties", "query", "type")
    %i[name description params_schema call].each do |method|
      assert_respond_to @tool, method
    end
  end
end
