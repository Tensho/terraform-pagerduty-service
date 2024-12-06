data "pagerduty_escalation_policy" "default" {
  name = var.escalation_policy_name
}
