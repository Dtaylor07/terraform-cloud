provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::199660179115:role/github-oidc-Role"
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