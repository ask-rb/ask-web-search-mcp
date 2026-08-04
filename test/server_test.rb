# frozen_string_literal: true

require_relative "test_helper"
require_relative "support/fake_searxng"

# Functional tests for the ask-web-search-mcp server, driven end-to-end with
# Ask::MCP::Client over a real stdio subprocess. SearXNG is stubbed by an
# in-process FakeSearxng so no network is involved.
class ServerTest < Minitest::Test
  def setup
    @searxng = FakeSearxng.new(results: [
      { url: "https://example.com", title: "Example", content: "An example page" }
    ])
    @script = File.expand_path("support/test_server.rb", __dir__)
  end

  def teardown
    @client&.stop rescue nil
    @searxng&.stop
    ObjectSpace.each_object(Ask::MCP::Transport::Stdio) { |t| t.stop rescue nil }
  end

  def spawn_client
    transport = Ask::MCP::Transport::Stdio.new(
      "ruby", [@script],
      env: {
        "BUNDLE_GEMFILE" => File.expand_path("../Gemfile", __dir__),
        "SEARXNG_URL" => @searxng.url
      }
    )
    @client = Ask::MCP::Client.new(transport, timeout: 5)
    @client.start
  end

  def test_negotiates_stateless_2026_07_28
    spawn_client
    assert @client.initialized?
    assert_equal "2026-07-28", @client.instance_variable_get(:@protocol_version),
                 "server should negotiate the stateless protocol via server/discover"
    assert @client.instance_variable_get(:@stateless),
           "a 2026-07-28 server must be used without the initialize handshake"
  end

  def test_lists_ask_web_search_tool
    spawn_client
    tools = @client.tools
    assert tools.key?("ask_web_search"), "expected ask_web_search tool, got #{tools.keys.inspect}"
    props = tools["ask_web_search"].input_schema[:properties]
    assert props.key?("query") || props.key?(:query), "tool must declare a query parameter"
  end

  def test_calls_tool_against_searxng
    spawn_client
    result = @client.call_tool("ask_web_search", { query: "ruby on rails" })
    text = result.is_a?(Array) ? result.first[:text] : result.dig(:content, 0, :text)
    assert_includes text, "1. Example"
    assert_includes text, "https://example.com"
    assert_includes text, "An example page"
    assert @searxng.requests.any? { |r| r.include?("ruby+on+rails") || r.include?("ruby%20on%20rails") },
           "the tool must query SearXNG with the given query"
  end

  def test_calls_tool_with_no_results
    searxng = FakeSearxng.new(results: [])
    transport = Ask::MCP::Transport::Stdio.new(
      "ruby", [@script],
      env: {
        "BUNDLE_GEMFILE" => File.expand_path("../Gemfile", __dir__),
        "SEARXNG_URL" => searxng.url
      }
    )
    @client = Ask::MCP::Client.new(transport, timeout: 5)
    @client.start
    result = @client.call_tool("ask_web_search", { query: "nothing" })
    text = result.is_a?(Array) ? result.first[:text] : result.dig(:content, 0, :text)
    assert_includes text, "No results found."
  ensure
    searxng&.stop
  end

  def test_unknown_tool_returns_error_result
    spawn_client
    result = @client.call_tool("no_such_tool", {})
    text = result.is_a?(Array) ? result.first[:text] : result.dig(:content, 0, :text)
    assert_match(/Tool not found/, text)
  end
end
