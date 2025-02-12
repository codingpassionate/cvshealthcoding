variable "repo_name" {
  description = "repo name"
  type        = string
  default     = "gif-generator"
}

variable "cluster_name" {
  description = "cluster name"
  type        = string
  default     = "media-generator-cluster"
}

variable "service_name" {
  description = "service name"
  type        = string
  default     = "gif-generator-service"
}

variable "aws_account_id" {
  description = "aws account id"
  type        = string
}