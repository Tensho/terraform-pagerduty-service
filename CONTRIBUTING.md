# Contributing

This project uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).

## Prerequisites

```shell
mise install
prek install
tflint --init
```

### Provider Authentication

```shell
export PAGERDUTY_SERVICE_REGION=US
export PAGERDUTY_TOKEN=<REDACTED>
export PAGERDUTY_USER_TOKEN=$PAGERDUTY_TOKEN
```

## Testing

Run module test suite:

```shell
terraform init
terraform test -verbose
```
