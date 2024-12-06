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

  cloudwatch_integration_enabled = true
  datadog_integration_enabled    = true
  newrelic_integration_enabled   = true
}

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
