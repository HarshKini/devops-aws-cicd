terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Alias for us-east-1 (needed for CloudFront metrics/alarms)
provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}
