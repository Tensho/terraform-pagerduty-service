resource "pagerduty_service_integration" "cloudwatch" {
  count = !var.business && var.cloudwatch_integration_enabled ? 1 : 0

  name    = data.pagerduty_vendor.cloudwatch[0].name
  vendor  = data.pagerduty_vendor.cloudwatch[0].id
  service = pagerduty_service.default[0].id
}

resource "pagerduty_service_integration" "datadog" {
  count = !var.business && var.datadog_integration_enabled ? 1 : 0

  name    = data.pagerduty_vendor.datadog[0].name
  vendor  = data.pagerduty_vendor.datadog[0].id
  service = pagerduty_service.default[0].id
}

resource "pagerduty_service_integration" "newrelic" {
  count = !var.business && var.newrelic_integration_enabled ? 1 : 0

  name    = data.pagerduty_vendor.newrelic[0].name
  vendor  = data.pagerduty_vendor.newrelic[0].id
  service = pagerduty_service.default[0].id
}
