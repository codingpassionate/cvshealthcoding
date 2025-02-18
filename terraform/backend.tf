terraform {
  backend "s3" {
    bucket  = "gif-generator-tf-state-bucket"
    key     = "ecs/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "terraform-lock"
  }
}
