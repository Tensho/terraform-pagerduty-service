resource "pagerduty_maintenance_window" "default" {
  count = !var.business && var.maintenance_window != null ? 1 : 0

  start_time  = var.maintenance_window.start_time
  end_time    = var.maintenance_window.end_time
  description = var.maintenance_window.description

  services = [pagerduty_service.default[0].id]
}
