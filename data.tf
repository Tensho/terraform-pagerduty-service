data "pagerduty_vendor" "cloudwatch" {
  count = var.cloudwatch_integration_enabled ? 1 : 0

  name = "Cloudwatch"
}

data "pagerduty_vendor" "datadog" {
  count = var.datadog_integration_enabled ? 1 : 0

  name = "Datadog"
}

data "pagerduty_vendor" "newrelic" {
  count = var.newrelic_integration_enabled ? 1 : 0

  name = "New Relic"
}
