data "pagerduty_escalation_policy" "default" {
  count = var.business ? 0 : 1

  name = var.escalation_policy_name
}

data "pagerduty_team" "default" {
  count = var.business ? 1 : 0

  name = var.team_name
}
