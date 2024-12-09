# PagerDuty Technical Service Example

A basic [PagerDuty technical service](https://support.pagerduty.com/main/docs/services-and-integrations) configuration.

## Prerequisites

* Export `PAGERDUTY_TOKEN` environment variable with a valid PagerDuty API user token.
* Export `PAGERDUTY_USER_TOKEN` environment variable with a valid PagerDuty API user token.

### Slack Integration

* [Authorise Slack workspace in PagerDuty](https://support.pagerduty.com/main/docs/slack-integration-guide#initial-configuration).
* Replace `workspace_id` parameter with your own Slack workspace ID.
* Replace `channel_id` parameter with your own Slack channel ID.

## Usage

```shell
terraform init
terraform apply
```
