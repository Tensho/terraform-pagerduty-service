# mock_provider "pagerduty" {}

variables {
  name                 = "Test"
  escalation_policy_id = "PBNPJZC"
}

run "defaults" {
  assert {
    condition = pagerduty_service.default[0].auto_resolve_timeout == "null"

    error_message = "PagerDuty service incident auto resolution is disabled"
  }

  assert {
    condition = pagerduty_service.default[0].acknowledgement_timeout == "null"

    error_message = "PagerDuty service incident aknowledgement reset is disabled"
  }

  assert {
    condition = pagerduty_service.default[0].auto_pause_notifications_parameters[0].enabled == false

    error_message = "PagerDuty service incident auto pause is disabled"
  }

  assert {
    condition = pagerduty_service.default[0].auto_pause_notifications_parameters[0].timeout == 120

    error_message = "PagerDuty service incident auto pause timeout is set to 120 seconds"
  }

  assert {
    condition = length(pagerduty_alert_grouping_setting.default) == 0

    error_message = "PagerDuty service alert grouping is disabled"
  }

  assert {
    condition = pagerduty_service.default[0].incident_urgency_rule[0].type == "constant"

    error_message = "PagerDuty service incident urgency rule type is constant"
  }

  assert {
    condition = pagerduty_service.default[0].incident_urgency_rule[0].urgency == "high"

    error_message = "PagerDuty service incident urgency rule urgency is high"
  }

  assert {
    condition = length(pagerduty_service.default[0].incident_urgency_rule[0].during_support_hours) == 0

    error_message = "PagerDuty service incident urgency rule during support hours is disabled"
  }

  assert {
    condition = length(pagerduty_service.default[0].incident_urgency_rule[0].outside_support_hours) == 0

    error_message = "PagerDuty service incident urgency rule outside support hours is disabled"
  }

  assert {
    condition = length(pagerduty_service.default[0].support_hours) == 0

    error_message = "PagerDuty service support hours is disabled"
  }

  assert {
    condition = length(pagerduty_service.default[0].scheduled_actions) == 0

    error_message = "PagerDuty service scheduled actions are disabled"
  }

  assert {
    condition = length(pagerduty_service_dependency.dependent) == 0

    error_message = "PagerDuty service dependent services list is empty"
  }

  assert {
    condition = length(pagerduty_service_dependency.supporting) == 0

    error_message = "PagerDuty service supporting services list is empty"
  }

  assert {
    condition = length(pagerduty_service_integration.cloudwatch) == 0

    error_message = "PagerDuty service CloudWatch integration is disabled"
  }

  assert {
    condition = length(pagerduty_service_integration.datadog) == 0

    error_message = "PagerDuty service DataDog integration is disabled"
  }

  assert {
    condition = length(pagerduty_service_integration.newrelic) == 0

    error_message = "PagerDuty service NewRelic integration is disabled"
  }

  assert {
    condition = length(pagerduty_slack_connection.default) == 0

    error_message = "PagerDuty service Slack connection is disabled"
  }

  assert {
    condition = length(pagerduty_event_orchestration_service.default) == 0

    error_message = "PagerDuty service event orchestration is disabled"
  }
}
