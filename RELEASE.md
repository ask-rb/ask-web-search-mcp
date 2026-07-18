# Release Process

## Prerequisites

- You have push access to the `ask-rb/ask-web-search-mcp` repository.
- You are logged in to RubyGems (`gem push` works).
- The SearXNG instance is running for integration tests.

## Release Steps

1. Update `lib/ask/web_search/mcp/version.rb` to the new version.
2. Update `CHANGELOG.md` with the new version and date.
3. Run tests: `bundle exec rake test`
4. Build: `bundle exec rake build`
5. Push to RubyGems: `bundle exec rake release`

## Quick Reference

```sh
bundle exec rake test     # Run tests
bundle exec rake build    # Build .gem
bundle exec rake release  # Push to RubyGems + git tag
```
