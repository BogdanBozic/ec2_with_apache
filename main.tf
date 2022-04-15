terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

provider "aws" {
  region     = var.availability_zone
  access_key = var.access_key
  secret_key = var.secret_key
}

module "second_task" {
  source           = "./terraform"
  account_id       = var.account_id
  subscriber_email = var.subscriber_email
}