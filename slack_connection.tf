resource "pagerduty_slack_connection" "default" {
  count = var.slack_connection != null ? 1 : 0

  source_type       = "service_reference"
  source_id         = pagerduty_service.default[0].id
  workspace_id      = var.slack_connection.workspace_id
  channel_id        = var.slack_connection.channel_id
  notification_type = var.slack_connection.notification_type

  config {
    events     = var.slack_connection.events
    urgency    = var.slack_connection.urgency
    priorities = var.slack_connection.priorities
  }
}
