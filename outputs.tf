output "sns_topic_name" {
  description = "Name of the created SNS Topic"
  value       = var.create_sns_topic ? local.aws_sns_topic.name : ""
}
