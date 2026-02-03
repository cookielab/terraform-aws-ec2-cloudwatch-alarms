locals {
  aws_sns_topic = var.create_sns_topic ? aws_sns_topic.this[0] : data.aws_sns_topic.this[0]
}

data "aws_region" "current" {}

data "aws_instance" "this" {
  instance_id = var.ec2_instance_id
}

data "aws_sns_topic" "this" {
  count = var.create_sns_topic ? 0 : 1

  name = var.sns_topic_name
}

resource "aws_sns_topic" "this" {
  count = var.create_sns_topic ? 1 : 0

  name = var.sns_topic_name
  tags = var.tags
}

resource "aws_sns_topic_subscription" "this" {
  count = var.create_sns_topic_subscription ? 1 : 0

  topic_arn = local.aws_sns_topic.arn
  protocol  = "email"
  endpoint  = var.sns_topic_subscription_email_address
}

resource "aws_cloudwatch_metric_alarm" "instance_check" {
  actions_enabled     = var.cloudwatch_alarm_options.instance.actions_enabled
  alarm_name          = "EC2InstanceStatusCheck: ${data.aws_instance.this.id}"
  alarm_description   = "EC2 instance Status Check for ${data.aws_instance.this.tags.Name} - reboot"
  comparison_operator = var.cloudwatch_alarm_options.instance.comparison_operator
  evaluation_periods  = var.cloudwatch_alarm_options.instance.evaluation_periods
  datapoints_to_alarm = var.cloudwatch_alarm_options.instance.datapoints_to_alarm
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = var.cloudwatch_alarm_options.instance.period
  statistic           = var.cloudwatch_alarm_options.instance.statistic
  threshold           = var.cloudwatch_alarm_options.instance.threshold
  treat_missing_data  = var.cloudwatch_alarm_options.instance.treat_missing_data
  ok_actions          = [local.aws_sns_topic.arn]
  alarm_actions = [
    "arn:aws:automate:${data.aws_region.current.region}:ec2:reboot",
    local.aws_sns_topic.arn
  ]
  dimensions = { InstanceId = data.aws_instance.this.id }
  tags       = var.tags
}

resource "aws_cloudwatch_metric_alarm" "system_check" {
  actions_enabled     = var.cloudwatch_alarm_options.system.actions_enabled
  alarm_name          = "EC2SystemStatusCheck: ${data.aws_instance.this.id}"
  alarm_description   = "EC2 System Status Check for ${data.aws_instance.this.tags.Name} - recover"
  comparison_operator = var.cloudwatch_alarm_options.system.comparison_operator
  evaluation_periods  = var.cloudwatch_alarm_options.system.evaluation_periods
  datapoints_to_alarm = var.cloudwatch_alarm_options.system.datapoints_to_alarm
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = var.cloudwatch_alarm_options.system.period
  statistic           = var.cloudwatch_alarm_options.system.statistic
  threshold           = var.cloudwatch_alarm_options.system.threshold
  treat_missing_data  = var.cloudwatch_alarm_options.system.treat_missing_data
  ok_actions          = [local.aws_sns_topic.arn]
  alarm_actions = [
    "arn:aws:automate:${data.aws_region.current.region}:ec2:recover",
    local.aws_sns_topic.arn
  ]
  dimensions = { InstanceId = data.aws_instance.this.id }
  tags       = var.tags
}
