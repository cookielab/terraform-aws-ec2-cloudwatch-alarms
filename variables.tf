variable "create_sns_topic" {
  description = "Toggle creation of SNS topic for Cloudwatch alarms"
  type        = bool
  default     = true
}

variable "create_sns_topic_subscription" {
  description = "Toggle creation of SNS Topic subscription"
  type        = bool
  default     = true
}

variable "sns_topic_name" {
  description = "SNS Topic name to use for alarms"
  type        = string
  default     = "ec2-cloudwatch-alarm"
}

variable "sns_topic_subscription_email_address" {
  description = "E-mail address for SNS Topic subscribtion"
  type        = string
  default     = null
}

variable "ec2_instance_id" {
  description = "EC2 Instance ID to create Cloudwatch alarms for"
  type        = string
}

variable "tags" {
  description = "Map of tags to be set on resources"
  type        = map(string)
  default     = {}
}

variable "cloudwatch_alarm_options" {
  description = "Cloudwatch Alarms options"
  type = object({
    instance = optional(object({
      actions_enabled     = optional(bool, true)
      comparison_operator = optional(string, "GreaterThanOrEqualToThreshold")
      evaluation_periods  = optional(number, 2)
      datapoints_to_alarm = optional(number, 2)
      period              = optional(number, 60)
      statistic           = optional(string, "Maximum")
      threshold           = optional(number, 1)
      treat_missing_data  = optional(string, "notBreaching")
    }), {})

    system = optional(object({
      actions_enabled     = optional(bool, true)
      comparison_operator = optional(string, "GreaterThanOrEqualToThreshold")
      evaluation_periods  = optional(number, 6)
      datapoints_to_alarm = optional(number, 6)
      period              = optional(number, 60)
      statistic           = optional(string, "Maximum")
      threshold           = optional(number, 1)
      treat_missing_data  = optional(string, "notBreaching")
    }), {})
  })
  default = {}
}
