output "pagerduty_service" {
  description = "PagerDuty service"
  value       = var.business ? pagerduty_business_service.default[0] : pagerduty_service.default[0]
}
