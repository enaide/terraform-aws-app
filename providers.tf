#-----------------------------------------
# Define Terrraform Providers and Backend
#-----------------------------------------
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "4.30.0"
        }

    }
}

#-----------------------------------------
# Provider: AWS
#-----------------------------------------
provider "aws" {
    region = "eu-west-1"
    profile = "devops"
    default_tags {
    tags = {
        environment = "dev"
        cost_center = "devops-department"
    }
  }
}