variable "business" {
  description = "PagerDuty business service vs technical service switch."
  type        = bool
  default     = false
}

variable "team_id" {
  description = "PagerDuty business service owner team ID (Business/Enterprise plan)."
  type        = string
  default     = null
}

variable "point_of_contact" {
  description = "PagerDuty business service point fo contact."
  type        = string
  default     = null
}

variable "name" {
  description = "PagerDuty service name"
  type        = string
}

variable "description" {
  description = "PagerDuty service description."
  type        = string
  default     = "Managed by Terraform"
}

variable "escalation_policy_id" {
  description = "PagerDuty service escalation policy ID."
  type        = string
  default     = null
}

variable "acknowledgement_timeout" {
  description = "PagerDuty service incident acknowledged-to-triggered state change time in seconds."
  type        = string
  default     = "null"
}

variable "auto_resolve_timeout" {
  description = "PagerDuty service incident auto resolution time in seconds."
  type        = string
  default     = "null"
}

variable "auto_pause_notifications_parameters" {
  description = "PagerDuty service transient incident auto pause before triggering (AIOps add-on)."
  type = object({
    enabled = bool,
    timeout = number,
  })
  default = {
    enabled = false
    timeout = null
  }
}

variable "alert_grouping_setting" {
  description = "PagerDuty service alert grouping configuration."

  type = object({
    type = string,
    config = object({
      timeout     = optional(number, 0),
      aggregate   = optional(string),
      fields      = optional(list(string), []),
      time_window = optional(number, 0),
    })
  })

  default = null

  # TODO: Add validations
}

variable "support_hours" {
  description = "PagerDuty service support hours."

  type = object({
    type         = optional(string, "fixed_time_per_day")
    time_zone    = string
    days_of_week = list(number)
    start_time   = string
    end_time     = string
  })

  default = null

  # TODO: Add validations
}

variable "incident_urgency_rule" {
  description = "PagerDuty service incident urgency rule."

  type = object({
    type    = string
    urgency = optional(string)
    during_support_hours = optional(object({
      type    = string
      urgency = string
    }))
    outside_support_hours = optional(object({
      type    = string
      urgency = string
    }))
  })

  default = null

  # TODO: Add validations
}

variable "scheduled_actions" {
  description = "PagerDuty service incident escalation actions related within support hours."

  type = object({
    type       = optional(string, "urgency_change")
    to_urgency = string
    at = object({
      type = optional(string, "named_time")
      name = string
    })
  })

  default = null

  # TODO: Add validations
}

variable "service_graph" {
  description = "PagerDuty service graph components."

  type = object({
    dependent_services = optional(list(object({
      name = string
      id   = string
      type = string
    })))
    supporting_services = optional(list(object({
      name = string
      id   = string
      type = string
    })))
  })

  default = {
    dependent_services  = []
    supporting_services = []
  }
}

variable "cloudwatch_integration_enabled" {
  description = "PagerDuty service AWS CloudWatch integration switch."
  type        = bool
  default     = false
}

variable "datadog_integration_enabled" {
  description = "PagerDuty service DataDog integration switch."
  type        = bool
  default     = false
}

variable "newrelic_integration_enabled" {
  description = "PagerDuty service NewRelic integration switch."
  type        = bool
  default     = false
}

variable "slack_connection" {
  description = "PagerDuty service Slack connection configuration."

  type = object({
    workspace_id      = optional(string), # `SLACK_CONNECTION_WORKSPACE_ID` env var
    channel_id        = string,
    notification_type = string,
    events            = list(string)
    urgency           = optional(string)
    priorities        = optional(list(string))
  })

  default = null

  # TODO: Add validations
}

variable "event_orchestration" {
  description = "PagerDuty service event orchestration configuration."

  type = object({
    enable_event_orchestration_for_service = optional(bool, true)
    sets = optional(list(object({
      id = string
      rules = list(object({
        label = optional(string)
        condition = optional(object({
          expression = string
        }))
        actions = object({
          annotate             = optional(string)
          escalation_policy_id = optional(string)
          priority_id          = optional(string)
          route_to             = optional(string)
          suppress             = optional(bool)
          suspend_seconds      = optional(number)
          variables = optional(list(object({
            name  = string
            path  = string
            value = string
            type  = string
          })), [])
          extractions = optional(list(object({
            target   = string
            template = optional(string)
            source   = optional(string)
            regex    = optional(string)
          })), [])
          incident_custom_field_updates = optional(list(object({
            id    = string
            value = string
          })), [])
          automation_action = optional(object({
            name          = string
            url           = string
            auto_send     = optional(bool, false)
            trigger_types = optional(list(string), [])
            parameters = optional(list(object({
              key   = string
              value = string
            })), [])
            headers = optional(list(object({
              key   = string
              value = string
            })), [])
          }))
          pagerduty_automation_action = optional(object({
            action_id     = string
            trigger_types = optional(list(string), [])
          }))
        })
      }))
    })), [])
    catch_all = optional(object({
      actions = object({
        annotate             = optional(string)
        escalation_policy_id = optional(string)
        priority_id          = optional(string)
        suppress             = optional(bool)
        suspend_seconds      = optional(number)
        pagerduty_automation_action = optional(object({
          action_id     = string
          trigger_types = optional(list(string), [])
        }))
      })
    }))
  })

  default = null

  # TODO: Add validations
}