output "pagerduty_service" {
  value       = module.example.pagerduty_service
  description = "PagerDuty service."
}

output "pagerduty_maintenance_window" {
  value       = module.example.pagerduty_maintenance_window
  description = "PagerDuty service maintenance window."
}

output "cloudwatch_integration_key" {
  value       = module.example.cloudwatch_integration_key
  description = "PagerDuty service CloudWatch integration key."
}

output "datadog_integration_key" {
  value       = module.example.datadog_integration_key
  description = "PagerDuty service DataDog integration key."
}

output "newrelic_integration_key" {
  value       = module.example.newrelic_integration_key
  description = "PagerDuty service NewRelic integration key."
}
