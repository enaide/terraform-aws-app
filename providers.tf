terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "4.30.0"
        }

        linode = {
            source = "linode/linode"
            version = "2.25.0"
        }
  }
}