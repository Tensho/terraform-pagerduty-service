mock_provider "pagerduty" {}

variables {
  name                 = "Test"
  escalation_policy_id = "ABCDEFG"

  event_orchestration = {
    sets = [
      {
        id = "start"

        rules = [
          {
            label = "Suppress low severity alerts"

            condition = {
              expression = "event.severity matches 'info'"
            }

            actions = {
              suppress = true
            }
          }
        ]
      }
    ]

    catch_all = {
      actions = {}
    }
  }
}

run "event_orchestration" {
  assert {
    condition = length(pagerduty_event_orchestration_service.default) != 0

    error_message = "PagerDuty service event orchestration is enabled"
  }
}
