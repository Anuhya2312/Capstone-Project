terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.19.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.51.0"
    }
  }
}

provider "aws" {
  # Configuration options
region = "us-east-1"
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "114ba48d-9717-4197-bb53-4c9cbd2e7795"
}
