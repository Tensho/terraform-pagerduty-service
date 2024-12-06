variable "name" {
  type        = string
  description = "PagerDuty service name"
}

variable "description" {
  type        = string
  default     = "Managed by Terraform"
  description = "PagerDuty service description."
}

variable "escalation_policy_name" {
  type        = string
  description = "PagerDuty service escalation policy name."
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
