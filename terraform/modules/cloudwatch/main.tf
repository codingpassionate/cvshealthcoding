resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = var.retention_in_days

  kms_key_id = var.kms_key_id != "" ? var.kms_key_id : null

  tags = {
    Name        = var.log_group_name
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_metric_filter" "unique_error_count" {
  name           = "UniqueErrorMetricFilter"
  log_group_name = var.log_group_name

  # Capture the whole error message dynamically
  pattern = "\"ERROR\""
  metric_transformation {
    name      = "UniqueErrorCountMetric"
    namespace = "LogMetrics"
    value     = "1"
  }
}
