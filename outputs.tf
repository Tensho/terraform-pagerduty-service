output "pagerduty_service" {
  value       = var.business ? pagerduty_business_service.default[0] : pagerduty_service.default[0]
  description = "PagerDuty service."
}

output "cloudwatch_integration_key" {
  value       = length(pagerduty_service_integration.cloudwatch) > 0 ? pagerduty_service_integration.cloudwatch[0].integration_key : null
  description = "PagerDuty service CloudWatch integration key."
}

output "datadog_integration_key" {
  value       = length(pagerduty_service_integration.datadog) > 0 ? pagerduty_service_integration.datadog[0].integration_key : null
  description = "PagerDuty service DataDog integration key."
}

output "newrelic_integration_key" {
  value       = length(pagerduty_service_integration.newrelic) > 0 ? pagerduty_service_integration.newrelic[0].integration_key : null
  description = "PagerDuty service NewRelic integration key."
}
