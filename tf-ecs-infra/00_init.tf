terraform {
  required_version = "~> 1.5.2"

  backend "s3" {
    region         = "us-east-2"
    bucket         = "pacely-terraform"
    key            = "prod-pacely.tfstate"
    dynamodb_table = "terraform_locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.9"
    }
  }
}
