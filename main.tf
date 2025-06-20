resource "pagerduty_business_service" "default" {
  count = var.business ? 1 : 0

  name             = var.name
  description      = var.description
  point_of_contact = var.point_of_contact
  team             = var.team_id
}

resource "pagerduty_service" "default" {
  count = var.business ? 0 : 1

  name              = var.name
  description       = var.description
  escalation_policy = var.escalation_policy_id

  auto_resolve_timeout    = var.auto_resolve_timeout
  acknowledgement_timeout = var.acknowledgement_timeout

  auto_pause_notifications_parameters {
    enabled = var.auto_pause_notifications_parameters.enabled
    timeout = var.auto_pause_notifications_parameters.timeout
  }

  dynamic "support_hours" {
    for_each = var.support_hours != null ? [var.support_hours] : []

    content {
      type         = support_hours.value.type
      start_time   = support_hours.value.start_time
      end_time     = support_hours.value.end_time
      time_zone    = support_hours.value.time_zone
      days_of_week = support_hours.value.days_of_week
    }
  }

  dynamic "incident_urgency_rule" {
    for_each = var.incident_urgency_rule != null ? [var.incident_urgency_rule] : []

    content {
      type    = incident_urgency_rule.value.type
      urgency = incident_urgency_rule.value.urgency

      dynamic "during_support_hours" {
        for_each = incident_urgency_rule.value.during_support_hours != null ? [incident_urgency_rule.value.during_support_hours] : []

        content {
          type    = during_support_hours.value.type
          urgency = during_support_hours.value.urgency
        }
      }

      dynamic "outside_support_hours" {
        for_each = incident_urgency_rule.value.outside_support_hours != null ? [incident_urgency_rule.value.outside_support_hours] : []

        content {
          type    = outside_support_hours.value.type
          urgency = outside_support_hours.value.urgency
        }
      }
    }
  }

  dynamic "scheduled_actions" {
    for_each = var.scheduled_actions != null ? [var.scheduled_actions] : []

    content {
      type       = scheduled_actions.value.type
      to_urgency = scheduled_actions.value.to_urgency

      at {
        type = scheduled_actions.value.at.type
        name = scheduled_actions.value.at.name
      }
    }
  }
}

resource "pagerduty_service_dependency" "dependent" {
  for_each = { for service in var.service_graph.dependent_services : service.name => service }

  dependency {
    dependent_service {
      type = pagerduty_service.default[0].type
      id   = pagerduty_service.default[0].id
    }

    supporting_service {
      type = each.value.type
      id   = each.value.id
    }
  }
}

resource "pagerduty_service_dependency" "supporting" {
  for_each = { for service in var.service_graph.supporting_services : service.name => service }

  dependency {
    dependent_service {
      type = each.value.type
      id   = each.value.id
    }

    supporting_service {
      type = pagerduty_service.default[0].type
      id   = pagerduty_service.default[0].id
    }
  }
}
