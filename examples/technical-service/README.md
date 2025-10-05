# PagerDuty Technical Service Example

A basic [PagerDuty technical service](https://support.pagerduty.com/main/docs/services-and-integrations) configuration.

## Usage

```shell
export PAGERDUTY_TOKEN=<REDACTED>
export PAGERDUTY_USER_TOKEN=$PAGERDUTY_TOKEN
terraform init
terraform apply
```

### Slack Integration

* [Authorise Slack workspace in PagerDuty](https://support.pagerduty.com/main/docs/slack-integration-guide#initial-configuration).
* Replace `workspace_id` parameter with your own Slack workspace ID.
* Replace `channel_id` parameter with your own Slack channel ID.