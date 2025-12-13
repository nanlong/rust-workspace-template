# justfile for df-erp project
# Run with `just <recipe-name>`

# Default recipe (show available commands)
default:
    @just --list

# Run format and clippy checks on core packages
lint:
    cargo fmt
    cargo clippy --all-targets --all-features --workspace

# Automatically fix lint issues in core packages
fix-lint:
    cargo clippy --fix --allow-dirty --workspace

# Check for unused dependencies in all packages
check-deps:
    cargo +nightly udeps --workspace --all-features
