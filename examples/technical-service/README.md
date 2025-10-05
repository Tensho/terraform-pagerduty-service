# PagerDuty Technical Service Example

A basic [PagerDuty technical service](https://support.pagerduty.com/main/docs/services-and-integrations) configuration.

## Usage

[Authorise Slack workspace in PagerDuty](https://support.pagerduty.com/main/docs/slack-integration-guide#initial-configuration).

```shell
export PAGERDUTY_TOKEN=<REDACTED>
export PAGERDUTY_USER_TOKEN=$PAGERDUTY_TOKEN
export TF_VAR_slack_workspace_id=<REDACTED>
export TF_VAR_slack_channel_id=<REDACTED> 
terraform init
terraform apply
```
