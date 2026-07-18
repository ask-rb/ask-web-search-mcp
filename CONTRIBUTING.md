# Contributing

Thanks for your interest! Please read the project's
[GOAL.md](GOAL.md) to understand what this gem is about.

## Development Setup

```sh
bin/setup
```

## Local Dependencies

- Ruby >= 3.2
- A running SearXNG instance (see [README](README.md))

## Running Tests

```sh
bundle exec rake test
```

## Code Style

We use RuboCop. Run it before committing:

```sh
bundle exec rubocop
```

## Pull Request Guidelines

- Keep PRs focused on a single concern.
- Add tests for new functionality.
- Update CHANGELOG.md.
- Ensure CI passes.

## Testing Philosophy

- We favour fast, deterministic unit tests.
- Integration tests against a real SearXNG instance live in `test/manual/`.

## Release

See [RELEASE.md](RELEASE.md).

## Gem Boundary

This gem is intentionally small — it wires together `ask-mcp` and
`ask-web-search` with no additional logic. If you need new behaviour,
consider contributing upstream to the relevant library.
