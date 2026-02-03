# Terraform module for EC2 cloudwatch alarms

This module will create AWS Cloudwatch metric alarms for instance and system, SNS topic and SNS topic subscription.

Instance reboot alarm has higher default `evaluation_periods` and `datapoints_to_alarm` to allow remediation using recover on system check failure when both alarms firing. Once a cloudwatch alarm gets into alarm state, the configured action is performed and message sent to SNS topic.

Alarms have `alarm_actions` configured as follows:
| Instance check      | System check       | Action  |
|---                  | ---                | ---     |
| :white_check_mark:  | :white_check_mark: | none    |
| :x:                 | :white_check_mark: | reboot  |
| :white_check_mark:  | :x:                | recover |
| :x:                 | :x:                | recover |

See [Requirements for enabling CloudWatch action based recovery](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/cloudwatch-recovery.html#requirements-for-cloudwatch-action-based-recovery)

## Usage

```terraform
module "static-site" {
  source  = "cookielab/ec2-cloudwatch-alarms/aws"
  version = "~> 1.0

  ec2_instance_id = "i-08bdd64b00da931ed"

  sns_topic_subscription_email_address = "monitoring@example.com"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.instance_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.system_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_alarm_options"></a> [cloudwatch\_alarm\_options](#input\_cloudwatch\_alarm\_options) | Cloudwatch Alarms options | <pre>object({<br/>    instance = optional(object({<br/>      actions_enabled     = optional(bool, true)<br/>      comparison_operator = optional(string, "GreaterThanOrEqualToThreshold")<br/>      evaluation_periods  = optional(number, 2)<br/>      datapoints_to_alarm = optional(number, 2)<br/>      period              = optional(number, 60)<br/>      statistic           = optional(string, "Maximum")<br/>      threshold           = optional(number, 1)<br/>      treat_missing_data  = optional(string, "notBreaching")<br/>    }), {})<br/><br/>    system = optional(object({<br/>      actions_enabled     = optional(bool, true)<br/>      comparison_operator = optional(string, "GreaterThanOrEqualToThreshold")<br/>      evaluation_periods  = optional(number, 6)<br/>      datapoints_to_alarm = optional(number, 6)<br/>      period              = optional(number, 60)<br/>      statistic           = optional(string, "Maximum")<br/>      threshold           = optional(number, 1)<br/>      treat_missing_data  = optional(string, "notBreaching")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_create_sns_topic"></a> [create\_sns\_topic](#input\_create\_sns\_topic) | Toggle creation of SNS topic for Cloudwatch alarms | `bool` | `true` | no |
| <a name="input_create_sns_topic_subscription"></a> [create\_sns\_topic\_subscription](#input\_create\_sns\_topic\_subscription) | Toggle creation of SNS Topic subscription | `bool` | `true` | no |
| <a name="input_ec2_instance_id"></a> [ec2\_instance\_id](#input\_ec2\_instance\_id) | EC2 Instance ID to create Cloudwatch alarms for | `string` | n/a | yes |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | SNS Topic name to use for alarms | `string` | `"ec2-cloudwatch-alarm"` | no |
| <a name="input_sns_topic_subscription_email_address"></a> [sns\_topic\_subscription\_email\_address](#input\_sns\_topic\_subscription\_email\_address) | E-mail address for SNS Topic subscribtion | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be set on resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_name"></a> [sns\_topic\_name](#output\_sns\_topic\_name) | Name of the created SNS Topic |
<!-- END_TF_DOCS -->
