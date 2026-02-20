mock_provider "pagerduty" {}

variables {
  name                 = "Test"
  escalation_policy_id = "ABCDEFG"

  cloudwatch_integration_enabled = true
  datadog_integration_enabled    = true
  newrelic_integration_enabled   = true
}

run "integrations" {
  assert {
    condition = length(pagerduty_service_integration.cloudwatch) != 0

    error_message = "PagerDuty service CloudWatch integration is enabled"
  }

  assert {
    condition = length(pagerduty_service_integration.datadog) != 0

    error_message = "PagerDuty service DataDog integration is enabled"
  }

  assert {
    condition = length(pagerduty_service_integration.newrelic) != 0

    error_message = "PagerDuty service NewRelic integration is enabled"
  }
}
