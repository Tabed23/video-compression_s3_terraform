provider "aws" {
  region = "us-east-1"
}



terraform {
  backend "s3" {
    bucket = "your-bucket"
    key    = "your-bucket/terraform.tfstate"
    region = "us-east-1"
  }
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

}
