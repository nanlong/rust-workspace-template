# justfile for df-erp project
# Run with `just <recipe-name>`

# Default recipe (show available commands)
default:
    @just --list

# Run format and clippy checks on core packages
lint:
    cargo +nightly fmt --all
    cargo clippy --workspace --all-targets --all-features --tests --benches -- -D warnings

# Automatically fix lint issues in core packages
fix-lint:
    cargo clippy --fix --allow-dirty --workspace

# Check for unused dependencies in all packages
check-deps:
    cargo +nightly udeps --workspace --all-features

# Run tests for all packages in the workspace
test:
    cargo nextest run --all-features --workspace --no-tests=pass

# Generate CHANGELOG.md
changelog:
    git cliff -o CHANGELOG.md

# Preview changelog (without writing)
changelog-preview:
    git cliff --unreleased

# Release a new version (usage: just release v0.1.0)
release version:
    git tag {% raw %}{{version}}{% endraw %}
    git cliff -o CHANGELOG.md
    git add CHANGELOG.md
    git commit -m "chore(release): prepare {% raw %}{{version}}{% endraw %}"
    git tag -f {% raw %}{{version}}{% endraw %}
    @echo "Run 'git push origin main --tags' to publish"
