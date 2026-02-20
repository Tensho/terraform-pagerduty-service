# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Terraform module published to the Terraform Registry as `Tensho/service/pagerduty`.
It provides a reusable "batteries included" solution for creating and configuring PagerDuty services – both Business and Technical service types.

## Development Setup

Tools are managed via `mise`. After installing mise, run:

```sh
mise install
```

Authentication requires a PagerDuty API token. Set `PAGERDUTY_TOKEN` in `.env` file. The `.env` file is autoloaded by mise.

## Common Commands

```sh
# Format check (non-destructive)
terraform fmt -check -recursive

# Format in place
terraform fmt -recursive

# Lint
tflint

# Run all tests
terraform test

# Run a specific test file
terraform test -filter=main.tftest.hcl -verbose

# Run pre-commit hooks on all files
prek run --all-files

# Initialize and test an example
cd examples/technical-service && terraform init && terraform apply -auto-approve && terraform destroy -auto-approve
```

## Architecture

The module follows a one-file-per-feature pattern at the root:

- **`main.tf`** — Core resources. Conditionally creates `pagerduty_business_service` OR `pagerduty_service` based on the `var.business` boolean. Also manages service dependencies.
- **`variables.tf`** — All input variables with complex nested object types.
- **`outputs.tf`** — Service object and integration keys.
- **`integration.tf`** — CloudWatch, DataDog, NewRelic service integrations.
- **`alert_grouping_setting.tf`** — AIOps alert grouping configuration.
- **`event_orchestration.tf`** — Event orchestration rules and automation actions.
- **`slack_connection.tf`** — Slack connection resource.
- **`data.tf`** — Vendor data source lookups.
- **`versions.tf`** — Provider requirements (Terraform >= 1.7.0, PagerDuty provider ~> 3.26).

### Tests

- `main.tftest.hcl` — Comprehensive assertions against default and feature behavior (runs against real PagerDuty API).
- `integration.tftest.hcl` — Integration (NewRelic, DataDog, CloudWatch) tests using mocked provider data.
- `maintenance_window.tftest.hcl` — Maintenance window tests using mocked provider data.

### Examples

- `examples/business-service/` — Minimal usage for a Business Service (no escalation policy needed).
- `examples/technical-service/` — Full-featured Technical Service with all integrations, event orchestration, Slack, and service graph dependencies.

## Conventions

- **Conventional Commits** are required (enforced via release-please for automated releases).
- **GitHub Actions are pinned to commit SHAs** — when updating actions, always use the full SHA, not a tag.
- Pre-commit hooks enforce `terraform fmt`, `terraform-docs`, and `tflint` automatically.
