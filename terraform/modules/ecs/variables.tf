variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = number
}

variable "task_memory" {
  description = "Memory for the task"
  type        = number
}

variable "container_image" {
  description = "Docker image to use"
  type        = string
}

variable "container_port" {
  description = "Port the container exposes"
  type        = number
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  type = string
}