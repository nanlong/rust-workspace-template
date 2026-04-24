# justfile for {{project-name}}
# Run with `just <recipe-name>`

# Default recipe (show available commands)
default:
    @just --list

# === 代码质量 ===

# Quick compile check (no codegen)
check:
    cargo check --workspace --all-features

# Run format and clippy checks on core packages (requires nightly toolchain)
lint:
    cargo +nightly fmt --all
    cargo clippy --workspace --all-targets --all-features -- -D warnings

# Automatically fix lint issues in core packages
fix-lint:
    cargo clippy --fix --allow-dirty --workspace --all-targets --all-features

# Check for unused dependencies (requires cargo-udeps + nightly toolchain)
check-deps:
    cargo +nightly udeps --workspace --all-features

# Audit dependencies for security advisories (requires cargo-audit)
audit:
    cargo audit

# === 测试 ===

# Run tests for all packages in the workspace
test:
    cargo nextest run --all-features --workspace --no-tests=pass

# Run tests with coverage report (requires cargo-llvm-cov)
coverage:
    cargo llvm-cov --workspace --all-features --html --open

# === 文档 ===

# Build and open documentation
doc:
    cargo doc --workspace --no-deps --open

# === 本地开发 ===

# bacon check (auto-rerun on save)
dev-check:
    bacon check

# bacon clippy (auto-rerun on save)
dev-clippy:
    bacon clippy

# bacon test (auto-rerun on save)
dev-test:
    bacon test

# bacon run (hot-restart on save)
dev:
    bacon run

# === 版本发布 ===

# Generate CHANGELOG.md
changelog:
    git cliff -o CHANGELOG.md

# Preview changelog (without writing)
changelog-preview:
    git cliff --unreleased

# Release a new version (usage: just release v0.1.0)
release version:
    #!/usr/bin/env bash
    set -euo pipefail
    git cliff --tag {% raw %}{{version}}{% endraw %} -o CHANGELOG.md
    git add CHANGELOG.md
    git commit -m "chore(release): prepare {% raw %}{{version}}{% endraw %}"
    git tag {% raw %}{{version}}{% endraw %}
    echo "Run 'git push origin main --tags' to publish"
