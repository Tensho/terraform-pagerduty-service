# PagerDuty Service Terraform Module

Terraform module to manage [PagerDuty](https://www.pagerduty.com) service resource (batteries included).

## Usage

> [!WARNING]
> Technical PagerDuty service can't be created without a reference to an escalation policy.
> Make sure to create an escalation policy before creating a service.

```hcl
module "example" {
  source  = "Tensho/service/pagerduty"
  version = "1.4.0"

  name                 = "Example"
  description          = "Example service managed by Terraform"
  escalation_policy_id = pagerduty_escalation_policy.example.id

  auto_resolve_timeout    = 3600
  acknowledgement_timeout = 600

  auto_pause_notifications_parameters = {
    enabled = true
    timeout = 120
  }

  alert_grouping_setting = {
    type = "content_based"

    config = {
      time_window = 300
      aggregate   = "all"
      fields      = ["summary"]
    }
  }

  support_hours = {
    type         = "fixed_time_per_day"
    time_zone    = "Europe/London"
    start_time   = "09:00:00"
    end_time     = "17:00:00"
    days_of_week = [1, 2, 3, 4, 5]
  }

  incident_urgency_rule = {
    type = "use_support_hours"

    during_support_hours = {
      type    = "constant"
      urgency = "high"
    }

    outside_support_hours = {
      type    = "constant"
      urgency = "low"
    }
  }

  scheduled_actions = {
    type       = "urgency_change"
    to_urgency = "high"

    at = {
      type = "named_time"
      name = "support_hours_start"
    }
  }
  
  event_orchestration = {
    enable_event_orchestration_for_service = true

    sets = [
      {
        id = "start"

        rules = [
          {
            label = "Suppress morning alerts"

            condition = {
              expression = "now in Mon,Tue,Wed,Thu,Fri,Sat,Sun 06:00:00 to 07:00:00 Europe/London"
            }

            actions = {
              suppress = true
            }
          }
        ]
      }
    ]

    catch_all = {
      actions = {
        route_to = "unrouted"
      }
    }
  }
}
```

Check out comprehensive examples in [`examples`](./examples) folder.

## Features

* [x] [PagerDuty business service](https://support.pagerduty.com/main/docs/business-services)
* [x] [PagerDuty service alert grouping](https://support.pagerduty.com/main/docs/intelligent-alert-grouping) (AIOps add-on)
* [x] [PagerDuty service graph](https://support.pagerduty.com/main/docs/service-graph)
* [x] [PagerDuty service Slack integration](https://support.pagerduty.com/main/docs/slack-integration-guide)
* [x] [PagerDuty service event orchestration](https://support.pagerduty.com/main/docs/event-orchestration#service-orchestrations)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_pagerduty"></a> [pagerduty](#requirement\_pagerduty) | >= 3.26 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_pagerduty"></a> [pagerduty](#provider\_pagerduty) | 3.18.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [pagerduty_alert_grouping_setting.default](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/alert_grouping_setting) | resource |
| [pagerduty_business_service.default](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/business_service) | resource |
| [pagerduty_event_orchestration_service.default](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/event_orchestration_service) | resource |
| [pagerduty_service.default](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service) | resource |
| [pagerduty_service_dependency.dependent](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_dependency) | resource |
| [pagerduty_service_dependency.supporting](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_dependency) | resource |
| [pagerduty_service_integration.cloudwatch](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_service_integration.datadog](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_service_integration.newrelic](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/service_integration) | resource |
| [pagerduty_slack_connection.default](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/resources/slack_connection) | resource |
| [pagerduty_vendor.cloudwatch](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/data-sources/vendor) | data source |
| [pagerduty_vendor.datadog](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/data-sources/vendor) | data source |
| [pagerduty_vendor.newrelic](https://registry.terraform.io/providers/pagerduty/pagerduty/latest/docs/data-sources/vendor) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acknowledgement_timeout"></a> [acknowledgement\_timeout](#input\_acknowledgement\_timeout) | PagerDuty service incident acknowledged-to-triggered state change time in seconds. | `string` | `"null"` | no |
| <a name="input_alert_grouping_setting"></a> [alert\_grouping\_setting](#input\_alert\_grouping\_setting) | PagerDuty service alert grouping configuration. | <pre>object({<br/>    type = string,<br/>    config = object({<br/>      timeout     = optional(number, 0),<br/>      aggregate   = optional(string),<br/>      fields      = optional(list(string), []),<br/>      time_window = optional(number, 0),<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_auto_pause_notifications_parameters"></a> [auto\_pause\_notifications\_parameters](#input\_auto\_pause\_notifications\_parameters) | PagerDuty service transient incident auto pause before triggering (AIOps add-on). | <pre>object({<br/>    enabled = bool,<br/>    timeout = number,<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "timeout": null<br/>}</pre> | no |
| <a name="input_auto_resolve_timeout"></a> [auto\_resolve\_timeout](#input\_auto\_resolve\_timeout) | PagerDuty service incident auto resolution time in seconds. | `string` | `"null"` | no |
| <a name="input_business"></a> [business](#input\_business) | PagerDuty business service vs technical service switch. | `bool` | `false` | no |
| <a name="input_cloudwatch_integration_enabled"></a> [cloudwatch\_integration\_enabled](#input\_cloudwatch\_integration\_enabled) | PagerDuty service AWS CloudWatch integration switch. | `bool` | `false` | no |
| <a name="input_datadog_integration_enabled"></a> [datadog\_integration\_enabled](#input\_datadog\_integration\_enabled) | PagerDuty service DataDog integration switch. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | PagerDuty service description. | `string` | `"Managed by Terraform"` | no |
| <a name="input_escalation_policy_id"></a> [escalation\_policy\_id](#input\_escalation\_policy\_id) | PagerDuty service escalation policy ID. | `string` | `null` | no |
| <a name="input_event_orchestration"></a> [event\_orchestration](#input\_event\_orchestration) | PagerDuty service event orchestration configuration. | <pre>object({<br/>    enable_event_orchestration_for_service = optional(bool, true)<br/>    sets = optional(list(object({<br/>      id = string<br/>      rules = list(object({<br/>        label = optional(string)<br/>        condition = optional(object({<br/>          expression = string<br/>        }))<br/>        actions = object({<br/>          annotate             = optional(string)<br/>          escalation_policy_id = optional(string)<br/>          priority_id          = optional(string)<br/>          route_to             = optional(string)<br/>          suppress             = optional(bool)<br/>          suspend_seconds      = optional(number)<br/>          variables = optional(list(object({<br/>            name  = string<br/>            path  = string<br/>            value = string<br/>            type  = string<br/>          })), [])<br/>          extractions = optional(list(object({<br/>            target   = string<br/>            template = optional(string)<br/>            source   = optional(string)<br/>            regex    = optional(string)<br/>          })), [])<br/>          incident_custom_field_updates = optional(list(object({<br/>            id    = string<br/>            value = string<br/>          })), [])<br/>          automation_action = optional(object({<br/>            name          = string<br/>            url           = string<br/>            auto_send     = optional(bool, false)<br/>            trigger_types = optional(list(string), [])<br/>            parameters = optional(list(object({<br/>              key   = string<br/>              value = string<br/>            })), [])<br/>            headers = optional(list(object({<br/>              key   = string<br/>              value = string<br/>            })), [])<br/>          }))<br/>          pagerduty_automation_action = optional(object({<br/>            action_id     = string<br/>            trigger_types = optional(list(string), [])<br/>          }))<br/>        })<br/>      }))<br/>    })), [])<br/>    catch_all = optional(object({<br/>      actions = object({<br/>        annotate             = optional(string)<br/>        escalation_policy_id = optional(string)<br/>        priority_id          = optional(string)<br/>        suppress             = optional(bool)<br/>        suspend_seconds      = optional(number)<br/>        pagerduty_automation_action = optional(object({<br/>          action_id     = string<br/>          trigger_types = optional(list(string), [])<br/>        }))<br/>      })<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_incident_urgency_rule"></a> [incident\_urgency\_rule](#input\_incident\_urgency\_rule) | PagerDuty service incident urgency rule. | <pre>object({<br/>    type    = string<br/>    urgency = optional(string)<br/>    during_support_hours = optional(object({<br/>      type    = string<br/>      urgency = string<br/>    }))<br/>    outside_support_hours = optional(object({<br/>      type    = string<br/>      urgency = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | PagerDuty service name | `string` | n/a | yes |
| <a name="input_newrelic_integration_enabled"></a> [newrelic\_integration\_enabled](#input\_newrelic\_integration\_enabled) | PagerDuty service NewRelic integration switch. | `bool` | `false` | no |
| <a name="input_point_of_contact"></a> [point\_of\_contact](#input\_point\_of\_contact) | PagerDuty business service point fo contact. | `string` | `null` | no |
| <a name="input_scheduled_actions"></a> [scheduled\_actions](#input\_scheduled\_actions) | PagerDuty service incident escalation actions related within support hours. | <pre>object({<br/>    type       = optional(string, "urgency_change")<br/>    to_urgency = string<br/>    at = object({<br/>      type = optional(string, "named_time")<br/>      name = string<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_service_graph"></a> [service\_graph](#input\_service\_graph) | PagerDuty service graph components. | <pre>object({<br/>    dependent_services = optional(list(object({<br/>      name = string<br/>      id   = string<br/>      type = string<br/>    })))<br/>    supporting_services = optional(list(object({<br/>      name = string<br/>      id   = string<br/>      type = string<br/>    })))<br/>  })</pre> | <pre>{<br/>  "dependent_services": [],<br/>  "supporting_services": []<br/>}</pre> | no |
| <a name="input_slack_connection"></a> [slack\_connection](#input\_slack\_connection) | PagerDuty service Slack connection configuration. | <pre>object({<br/>    workspace_id      = string,<br/>    channel_id        = string,<br/>    notification_type = string,<br/>    events            = list(string)<br/>    urgency           = optional(string)<br/>    priorities        = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_support_hours"></a> [support\_hours](#input\_support\_hours) | PagerDuty service support hours. | <pre>object({<br/>    type         = optional(string, "fixed_time_per_day")<br/>    time_zone    = string<br/>    days_of_week = list(number)<br/>    start_time   = string<br/>    end_time     = string<br/>  })</pre> | `null` | no |
| <a name="input_team_id"></a> [team\_id](#input\_team\_id) | PagerDuty business service owner team ID (Business/Enterprise plan). | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_integration_key"></a> [cloudwatch\_integration\_key](#output\_cloudwatch\_integration\_key) | PagerDuty service CloudWatch integration key. |
| <a name="output_datadog_integration_key"></a> [datadog\_integration\_key](#output\_datadog\_integration\_key) | PagerDuty service DataDog integration key. |
| <a name="output_newrelic_integration_key"></a> [newrelic\_integration\_key](#output\_newrelic\_integration\_key) | PagerDuty service NewRelic integration key. |
| <a name="output_pagerduty_service"></a> [pagerduty\_service](#output\_pagerduty\_service) | PagerDuty service. |
<!-- END_TF_DOCS -->

## Contributing

This project uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).

### Prerequisites

#### MacOS

```shell
brew install pre-commit tfswitch terraform-docs tflint
pre-commit install --install-hooks
tflint --init
```

#### Provider Authentication

```shell
export PAGERDUTY_SERVICE_REGION=eu
export PAGERDUTY_TOKEN=<REDACTED>
export PAGERDUTY_USER_TOKEN=$PAGERDUTY_TOKEN
```

### Development

#### Business Service

```shell
cd examples/business-service
terraform init
terraform apply
terraform destroy
```

#### Technical Service

```shell
cd examples/technical-service
terraform init
terraform apply
terraform destroy
```

### Testing

```shell
terraform init
terraform test
terraform test -filter main.tftest.hcl -verbose
```

### Documentation

* [ ] Update "Usage" section in [`README.md`](./README.md)
* [ ] Update examples in `examples` folder
