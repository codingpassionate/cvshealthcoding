resource "aws_cloudwatch_metric_alarm" "unique_log_error_alarm" {
  alarm_name          = "RepeatedUniqueErrorAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 10  # Trigger alarm if same error appears 10+ times
  metric_name         = "UniqueErrorCountMetric"
  namespace           = "LogMetrics"
  statistic           = "Sum"
  period              = 60  # Check logs every 60 seconds

  alarm_description = "Triggers if the same error appears more than 10 times in one minute."

  alarm_actions = [aws_sns_topic.log_alerts.arn] # Optional: SNS Notification
}
