mock_provider "pagerduty" {}

variables {
  name                 = "Test"
  escalation_policy_id = "ABCDEFG"

  maintenance_window = {
    start_time  = "2026-03-01T20:00:00-05:00"
    end_time    = "2026-03-01T22:00:00-05:00"
    description = "Scheduled maintenance (managed by Terraform)"
  }
}

run "maintenance_window" {
  assert {
    condition = length(pagerduty_maintenance_window.default) != 0

    error_message = "PagerDuty service maintenance window is enabled"
  }
}
