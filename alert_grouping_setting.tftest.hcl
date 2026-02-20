mock_provider "pagerduty" {}

variables {
  name                 = "Test"
  escalation_policy_id = "ABCDEFG"

  alert_grouping_setting = {
    type = "content_based"

    config = {
      time_window = 300
      aggregate   = "all"
      fields      = ["summary"]
    }
  }
}

run "alert_grouping_setting" {
  assert {
    condition = length(pagerduty_alert_grouping_setting.default) != 0

    error_message = "PagerDuty service alert grouping setting is enabled"
  }
}
