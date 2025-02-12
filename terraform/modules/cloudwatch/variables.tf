variable "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "kms_key_id" {
  description = "KMS Key ID for log group encryption (optional)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}
