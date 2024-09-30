provider "aws" {

}

terraform {
  backend "s3" {
    bucket  = "terraform-state-file"
    key     = "security/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}