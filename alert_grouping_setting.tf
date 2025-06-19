resource "pagerduty_alert_grouping_setting" "default" {
  count = !var.business && var.alert_grouping_setting != null ? 1 : 0

  services = [pagerduty_service.default[0].id]

  name        = "Managed by Terraform"
  description = "Managed by Terraform"

  type = var.alert_grouping_setting.type

  config {
    time_window = var.alert_grouping_setting.config.time_window
    aggregate   = var.alert_grouping_setting.config.aggregate
    fields      = var.alert_grouping_setting.config.fields
  }
}
