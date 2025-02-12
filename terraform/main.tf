module "vpc" {
  source              = "./modules/vpc"
  vpc_name            = "gif-app-vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  azs                 = ["ap-south-1a"]
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "s3" {
  source            = "./modules/s3"
  bucket_name       = "gif-app-data"
  enable_versioning = true
  environment       = "prod"
}

module "cloudwatch" {
  source            = "./modules/cloudwatch"
  log_group_name    = "gif-app-log-group"
  retention_in_days = 60
  environment       = "prod"
}

module "ecs" {
  source             = "./modules/ecs"
  cluster_name       = var.cluster_name
  service_name       = var.service_name
  task_cpu           = 256
  task_memory        = 512
  assign_public_ip   = true
  container_image    = "${var.aws_account_id}.dkr.ecr.ap-south-1.amazonaws.com/${var.repo_name}"
  desired_count      = 1 #increase if required
  subnets            = module.vpc.public_subnets
  container_port     = 80
  security_groups    = [module.security_group.ecs_sg_id] # Attach security group
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  log_group_name     = module.cloudwatch.log_group_name
}

module "ecr" {
  source       = "./modules/ecr"
  repo_name    = var.repo_name
  scan_on_push = true
}

module "iam" {
  source         = "./modules/iam"
  s3_bucket_name = module.s3.bucket_name
}
