mock_provider "pagerduty" {}

variables {
  name                 = "Test"
  escalation_policy_id = "ABCDEFG"

  slack_connection = {
    workspace_id      = "T12345678"
    channel_id        = "C12345678"
    notification_type = "responder"

    events = [
      "incident.triggered",
      "incident.resolved",
    ]
  }
}

run "slack_connection" {
  assert {
    condition = length(pagerduty_slack_connection.default) != 0

    error_message = "PagerDuty service Slack connection is enabled"
  }
}
