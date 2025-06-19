resource "pagerduty_event_orchestration_service" "default" {
  count = !var.business && var.event_orchestration != null ? 1 : 0

  service                                = pagerduty_service.default[0].id
  enable_event_orchestration_for_service = var.event_orchestration.enable_event_orchestration_for_service

  dynamic "set" {
    for_each = var.event_orchestration.sets

    content {
      id = set.value.id

      dynamic "rule" {
        for_each = set.value.rules

        content {
          label = rule.value.label

          dynamic "condition" {
            for_each = rule.value.condition != null ? [rule.value.condition] : []

            content {
              expression = condition.value.expression
            }
          }

          actions {
            annotate          = rule.value.actions.annotate
            escalation_policy = rule.value.actions.escalation_policy_id
            priority          = rule.value.actions.priority_id
            route_to          = rule.value.actions.route_to
            suppress          = rule.value.actions.suppress
            suspend           = rule.value.actions.suspend_seconds

            dynamic "variable" {
              for_each = rule.value.actions.variables

              content {
                name  = variable.value.name
                path  = variable.value.path
                value = variable.value.value
                type  = variable.value.type
              }
            }

            dynamic "extraction" {
              for_each = rule.value.actions.extractions

              content {
                target   = extraction.value.target
                template = extraction.value.template
                source   = extraction.value.source
                regex    = extraction.value.regex
              }
            }

            dynamic "incident_custom_field_update" {
              for_each = rule.value.actions.incident_custom_field_updates

              content {
                id    = incident_custom_field_update.value.id
                value = incident_custom_field_update.value.value
              }
            }

            dynamic "automation_action" {
              for_each = rule.value.actions.automation_action != null ? [rule.value.actions.automation_action] : []

              content {
                name          = automation_action.value.name
                url           = automation_action.value.url
                auto_send     = automation_action.value.auto_send
                trigger_types = automation_action.value.trigger_types

                dynamic "parameter" {
                  for_each = automation_action.value.parameters

                  content {
                    key   = parameter.value.key
                    value = parameter.value.value
                  }
                }

                dynamic "header" {
                  for_each = automation_action.value.headers

                  content {
                    key   = header.value.key
                    value = header.value.value
                  }
                }
              }
            }

            dynamic "pagerduty_automation_action" {
              for_each = rule.value.actions.pagerduty_automation_action != null ? [rule.value.actions.pagerduty_automation_action] : []
              content {
                action_id     = pagerduty_automation_action.value.action_id
                trigger_types = pagerduty_automation_action.value.trigger_types
              }
            }
          }
        }
      }
    }
  }

  dynamic "catch_all" {
    for_each = var.event_orchestration.catch_all != null ? [var.event_orchestration.catch_all] : []

    content {
      actions {
        annotate          = catch_all.value.actions.annotate
        escalation_policy = catch_all.value.actions.escalation_policy_id
        priority          = catch_all.value.actions.priority_id
        suppress          = catch_all.value.actions.suppress
        suspend           = catch_all.value.actions.suspend_seconds

        dynamic "pagerduty_automation_action" {
          for_each = catch_all.value.actions.pagerduty_automation_action != null ? [catch_all.value.actions.pagerduty_automation_action] : []

          content {
            action_id     = pagerduty_automation_action.value.action_id
            trigger_types = pagerduty_automation_action.value.trigger_types
          }
        }
      }
    }
  }
}