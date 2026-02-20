#################
# Prerequisites #
#################
data "pagerduty_users" "all" {}

resource "pagerduty_escalation_policy" "example" {
  name = "Example"

  rule {
    escalation_delay_in_minutes = 1

    target {
      type = "user_reference"
      id   = data.pagerduty_users.all.users[0].id
    }
  }
}

data "pagerduty_priority" "p1" {
  name = "P1"
}

resource "pagerduty_incident_custom_field" "impact" {
  name         = "impact"
  display_name = "Impact"
  field_type   = "single_value"
  data_type    = "string"
}

#################
# Target module #
#################
module "example" {
  source = "../../"

  name                 = "Example"
  escalation_policy_id = pagerduty_escalation_policy.example.id

  auto_resolve_timeout    = 3600
  acknowledgement_timeout = 600

  auto_pause_notifications_parameters = {
    enabled = true
    timeout = 120
  }

  alert_grouping_setting = {
    type = "content_based"

    config = {
      time_window = 300
      aggregate   = "all"
      fields      = ["summary"]
    }
  }

  support_hours = {
    type         = "fixed_time_per_day"
    time_zone    = "Europe/London"
    start_time   = "09:00:00"
    end_time     = "17:00:00"
    days_of_week = [1, 2, 3, 4, 5]
  }

  incident_urgency_rule = {
    type = "use_support_hours"

    during_support_hours = {
      type    = "constant"
      urgency = "high"
    }

    outside_support_hours = {
      type    = "constant"
      urgency = "low"
    }
  }

  scheduled_actions = {
    type       = "urgency_change"
    to_urgency = "high"

    at = {
      type = "named_time"
      name = "support_hours_start"
    }
  }

  service_graph = {
    dependent_services = [
      {
        name = module.order_api.pagerduty_service.name
        type = module.order_api.pagerduty_service.type
        id   = module.order_api.pagerduty_service.id
      },
      {
        name = module.inventory_api.pagerduty_service.name
        type = module.inventory_api.pagerduty_service.type
        id   = module.inventory_api.pagerduty_service.id
      },
    ]

    supporting_services = [
      {
        name = module.payments_api.pagerduty_service.name
        type = module.payments_api.pagerduty_service.type
        id   = module.payments_api.pagerduty_service.id
      },
      {
        name = module.shipping_api.pagerduty_service.name
        type = module.shipping_api.pagerduty_service.type
        id   = module.shipping_api.pagerduty_service.id
      },
    ]
  }

  maintenance_window = {
    start_time  = "2026-03-01T20:00:00-05:00"
    end_time    = "2026-03-01T22:00:00-05:00"
    description = "Scheduled maintenance for database migration"
  }

  cloudwatch_integration_enabled = true
  datadog_integration_enabled    = true
  newrelic_integration_enabled   = true

  slack_connection = {
    workspace_id      = var.slack_workspace_id
    channel_id        = var.slack_channel_id
    notification_type = "responder"
    events = [
      "incident.triggered",
      "incident.acknowledged",
      "incident.escalated",
      "incident.reassigned",
      "incident.annotated",
      "incident.unacknowledged",
      "incident.delegated",
      "incident.priority_updated",
      "incident.responder.added",
      "incident.responder.replied",
      "incident.status_update_published",
      "incident.reopened",
      "incident.action_invocation.created",
      "incident.action_invocation.updated",
      "incident.action_invocation.terminated",
      "incident.role.assigned",
      "incident.incident_type.updated",
      "incident.resolved",
    ]
    urgency    = "high"
    priorities = ["*"]
  }

  event_orchestration = {
    enable_event_orchestration_for_service = true

    sets = [
      {
        id = "start"

        rules = [
          {
            label = "Suppress morning alerts"

            condition = {
              expression = "now in Mon,Tue,Wed,Thu,Fri,Sat,Sun 06:00:00 to 07:00:00 Europe/London"
            }

            actions = {
              suppress = true
            }
          },
          {
            label = "Apply consistent transformations"

            actions = {
              variable = {
                name  = "hostname"
                path  = "event.component"
                value = "hostname: (.*)"
                type  = "regex"
              }

              extractions = [
                {
                  template = "{{variables.hostname}}"
                  target   = "event.custom_details.hostname"
                },
                {
                  source = "event.source"
                  regex  = "www (.*) service"
                  target = "event.source"
                }
              ]

              route_to = "step-two"
            }
          }
        ]
      },
      {
        id = "step-two"

        rules = [
          {
            label = "All critical alerts should be treated as P1 incident"

            condition = {
              expression = "event.severity matches 'critical'"
            }

            actions = {
              annotate = "Please use our P1 runbook: https://docs.test/p1-runbook"
              priority = data.pagerduty_priority.p1.id

              incident_custom_field_update = {
                id    = pagerduty_incident_custom_field.impact.id
                value = "High Impact"
              }
            }
          },
          {
            label = "If there's something wrong on the canary let the team know about it in our deployments Slack channel"
            condition = {
              expression = "event.custom_details.hostname matches part 'canary'"
            }

            actions = {
              automation_action = {
                name          = "Canary Slack Notification"
                url           = "https://our-slack-listerner.test/canary-notification"
                auto_send     = true
                trigger_types = ["alert_triggered"]

                parameters = [
                  {
                    key   = "channel"
                    value = "#my-team-channel"
                  },
                  {
                    key   = "message"
                    value = "something is wrong with the canary deployment"
                  }
                ]

                header = {
                  key   = "X-Notification-Source"
                  value = "PagerDuty Incident Webhook"
                }
              }
            }
          },
          {
            label = "Never bother the on-call for info-level events outside of work hours, and let an Automation Action fix it instead"
            condition = {
              expression = "event.severity matches 'info' and not (now in Mon,Tue,Wed,Thu,Fri 09:00:00 to 17:00:00 America/Los_Angeles)"
            }
            actions = {
              suppress = true
              pagerduty_automation_action = {
                action_id     = "01FJV5A8OA5MKHOYFHV35SM2Z0"
                trigger_types = ["alert_suppressed"]
              }
            }
          }
        ]
      }
    ]

    catch_all = {
      actions = {
        route_to = "unrouted"
      }
    }
  }
}

######################
# Supporting modules #
######################
module "order_api" {
  source = "../../"

  name                 = "Orders API"
  escalation_policy_id = pagerduty_escalation_policy.example.id
}

module "inventory_api" {
  source = "../../"

  name                 = "Inventory API"
  escalation_policy_id = pagerduty_escalation_policy.example.id
}

module "payments_api" {
  source = "../../"

  name                 = "Payments API"
  escalation_policy_id = pagerduty_escalation_policy.example.id
}

module "shipping_api" {
  source = "../../"

  name                 = "Shipping API"
  escalation_policy_id = pagerduty_escalation_policy.example.id
}
