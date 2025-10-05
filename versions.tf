terraform {
  required_version = ">= 1.7.0"

  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "~> 3.26"
    }
  }
}
