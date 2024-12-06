# mock_provider "pagerduty" {}

variables {
  name                   = "Test"
  escalation_policy_name = "Primary"
}

run "defaults" {
  assert {
    condition = pagerduty_service.default.auto_resolve_timeout == "null"

    error_message = "PagerDuty service incident auto resolution is disabled"
  }

  assert {
    condition = pagerduty_service.default.acknowledgement_timeout == "null"

    error_message = "PagerDuty service incident aknowledgement reset is disabled"
  }

  assert {
    condition = pagerduty_service.default.auto_pause_notifications_parameters[0].enabled == false

    error_message = "PagerDuty service incident auto pause is disabled"
  }

  assert {
    condition = pagerduty_service.default.auto_pause_notifications_parameters[0].timeout == 120

    error_message = "PagerDuty service incident auto pause timeout is set to 120 seconds"
  }

  assert {
    condition = length(pagerduty_alert_grouping_setting.default) == 0

    error_message = "PagerDuty service alert grouping is disabled"
  }

  assert {
    condition = pagerduty_service.default.incident_urgency_rule[0].type == "constant"

    error_message = "PagerDuty service incident urgency rule type is constant"
  }

  assert {
    condition = pagerduty_service.default.incident_urgency_rule[0].urgency == "high"

    error_message = "PagerDuty service incident urgency rule urgency is high"
  }

  assert {
    condition = length(pagerduty_service.default.incident_urgency_rule[0].during_support_hours) == 0

    error_message = "PagerDuty service incident urgency rule during support hours is disabled"
  }

  assert {
    condition = length(pagerduty_service.default.incident_urgency_rule[0].outside_support_hours) == 0

    error_message = "PagerDuty service incident urgency rule outside support hours is disabled"
  }

  assert {
    condition = length(pagerduty_service.default.support_hours) == 0

    error_message = "PagerDuty service support hours is disabled"
  }

  # assert {
  #   condition = pagerduty_service.default.support_hours[0].time_zone == ""
  #
  #   error_message = "PagerDuty service support hours time zone is ?"
  # }
  #
  # assert {
  #   condition = pagerduty_service.default.support_hours[0].days_of_week == []
  #
  #   error_message = "PagerDuty service support hours days of week list is empty"
  # }
  #
  # assert {
  #   condition = pagerduty_service.default.support_hours[0].start_time == null
  #
  #   error_message = "PagerDuty service support hours start time is disabled"
  # }
  #
  # assert {
  #   condition = pagerduty_service.default.support_hours[0].end_time == null
  #
  #   error_message = "PagerDuty service support hours end time is disabled"
  # }

  assert {
    condition = length(pagerduty_service.default.scheduled_actions) == 0

    error_message = "PagerDuty service scheduled actions are disabled"
  }
}
