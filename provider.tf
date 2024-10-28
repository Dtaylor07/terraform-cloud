provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = var.AWS_ROLE_ARN
    session_name = "TerraformCloudSession"
  }
}

terraform {
  backend "s3" {
    bucket  = "terraform-state-file-latest"
    key     = "security/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}