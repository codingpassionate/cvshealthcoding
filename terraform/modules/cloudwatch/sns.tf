resource "aws_sns_topic" "log_alerts" {
  name = "log-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.log_alerts.arn
  protocol  = "email"
  endpoint  = "nirav127@gmail.com"
}