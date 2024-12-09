variable "business" {
  type        = bool
  default     = false
  description = "PagerDuty business service vs technical service switch."
}

variable "team_id" {
  type        = string
  default     = null
  description = "PagerDuty business service owner team ID (Business/Enterprise plan)."
}

variable "point_of_contact" {
  type        = string
  default     = null
  description = "PagerDuty business service point fo contact."
}

variable "name" {
  type        = string
  description = "PagerDuty service name"
}

variable "description" {
  type        = string
  default     = "Managed by Terraform"
  description = "PagerDuty service description."
}

variable "escalation_policy_id" {
  type        = string
  default     = null
  description = "PagerDuty service escalation policy ID."
}

variable "acknowledgement_timeout" {
  type        = string
  default     = "null"
  description = "PagerDuty service incident acknowledged-to-triggered state change time in seconds."
}

variable "auto_resolve_timeout" {
  type        = string
  default     = "null"
  description = "PagerDuty service incident auto resolution time in seconds."
}

variable "auto_pause_notifications_parameters" {
  type = object({
    enabled = bool,
    timeout = number,
  })
  default = {
    enabled = false
    timeout = null
  }
  description = "PagerDuty service transient incident auto pause before triggering (AIOps add-on)."
}

variable "alert_grouping_setting" {
  type = object({
    type = string,
    config = object({
      timeout     = optional(number, 0),
      aggregate   = optional(string),
      fields      = optional(list(string)),
      time_window = optional(number, 0),
    })
  })
  default     = null
  description = "PagerDuty service alert grouping configuration."

  # TODO: Add validations
}

variable "support_hours" {
  type = object({
    type         = optional(string, "fixed_time_per_day")
    time_zone    = string
    days_of_week = list(number)
    start_time   = string
    end_time     = string
  })
  default     = null
  description = "PagerDuty service support hours."

  # TODO: Add validations
}

variable "incident_urgency_rule" {
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
  default     = null
  description = "PagerDuty service incident urgency rule."

  # TODO: Add validations
}

variable "scheduled_actions" {
  type = object({
    type       = optional(string, "urgency_change")
    to_urgency = string
    at = object({
      type = optional(string, "named_time")
      name = string
    })
  })
  default     = null
  description = "PagerDuty service incident escalation actions related within support hours."

  # TODO: Add validations
}

variable "service_graph" {
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
  description = "PagerDuty service graph components."
}

variable "cloudwatch_integration_enabled" {
  type        = bool
  default     = false
  description = "PagerDuty service AWS CloudWatch integration switch."
}

variable "datadog_integration_enabled" {
  type        = bool
  default     = false
  description = "PagerDuty service DataDog integration switch."
}

variable "newrelic_integration_enabled" {
  type        = bool
  default     = false
  description = "PagerDuty service NewRelic integration switch."
}

variable "slack_connection" {
  type = object({
    workspace_id      = string,
    channel_id        = string,
    notification_type = string,
    events            = list(string)
    urgency           = optional(string)
    priorities        = optional(list(string))
  })
  default     = null
  description = "PagerDuty service Slack connection configuration."

  # TODO: Add validations
}
