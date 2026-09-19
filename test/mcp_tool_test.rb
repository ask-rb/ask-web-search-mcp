# frozen_string_literal: true

require_relative "test_helper"
require_relative "support/fake_searxng"

# Unit tests for the tool wiring, without spawning the stdio server.
class MCPToolTest < Minitest::Test
  def setup
    @tool = Ask::WebSearch::MCP.tool
  end

  def test_exposes_the_tool_under_the_ask_web_search_name
    assert_equal "ask_web_search", @tool.name
    assert_kind_of Ask::WebSearch::MCP::Tool, @tool
  end

  def test_satisfies_the_duck_typed_mcp_tool_contract
    refute_empty @tool.description
    assert_includes @tool.params_schema["required"], "query"
    assert_equal "string", @tool.params_schema.dig("properties", "query", "type")
    %i[name description params_schema call].each do |method|
      assert_respond_to @tool, method
    end
  end

  def test_schema_exposes_the_optional_time_range_and_categories_parameters
    schema = @tool.params_schema
    assert_equal %w[day week month year], schema.dig("properties", "time_range", "enum")
    assert_equal %w[general news science], schema.dig("properties", "categories", "enum")
    assert_equal ["query"], schema["required"]
  end

  def test_forwards_the_optional_parameters_to_the_library
    searxng = FakeSearxng.new(results: [{ url: "https://example.com", title: "Example", content: "An example page" }])
    Ask::WebSearch.searxng_url = searxng.url
    text = @tool.call("query" => "test", "time_range" => "week", "categories" => "news")
    assert_includes text, "1. Example"
    assert searxng.requests.any? { |r| r.include?("time_range=week") && r.include?("categories=news") },
           "expected the request line to carry the new params, got #{searxng.requests.inspect}"
  ensure
    Ask::WebSearch.searxng_url = nil
    searxng&.stop
  end

  def test_omits_the_optional_parameters_from_the_request_when_not_given
    searxng = FakeSearxng.new(results: [])
    Ask::WebSearch.searxng_url = searxng.url
    assert_equal "No results found.", @tool.call("query" => "test")
    assert searxng.requests.all? { |r| !r.include?("time_range=") && !r.include?("categories=") },
           "expected no time_range/categories in the request line, got #{searxng.requests.inspect}"
  ensure
    Ask::WebSearch.searxng_url = nil
    searxng&.stop
  end

  def test_reports_an_invalid_time_range_as_a_tool_error_the_agent_can_correct
    text = @tool.call("query" => "test", "time_range" => "fortnight")
    assert_match(%r{Error: ArgumentError: invalid time_range "fortnight"}, text)
    assert_includes text, "day, week, month, year"
  end
end
