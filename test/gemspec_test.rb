require_relative "test_helper"

class GemspecTest < Minitest::Test
  def spec
    @spec ||= Gem::Specification.load(File.expand_path("../ask-web-search-mcp.gemspec", __dir__))
  end

  def test_gemspec_is_valid
    assert spec
    assert_kind_of Gem::Specification, spec
    assert spec.name.to_s.start_with?("ask-")
    assert spec.version.to_s > "0"
  end

  def test_requires_stateless_capable_ask_mcp
    # The stateless 2026-07-28 negotiation (server/discover) landed in the
    # ask-mcp 0.4 line; anything older only speaks the legacy handshake.
    dep = spec.dependencies.find { |d| d.name == "ask-mcp" }
    refute_nil dep, "gemspec must depend on ask-mcp"
    ops = dep.requirement.requirements
    assert ops.any? { |op, version| op == ">=" && version >= Gem::Version.new("0.4") },
           "ask-mcp dependency must be >= 0.4, got #{dep.requirement}"
  end
end
