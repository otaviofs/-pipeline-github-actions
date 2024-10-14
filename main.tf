terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.71.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.5.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "otaviofsterraformstate"
    container_name       = "romete-state"
    key                  = "pipeline-github/terraform.tfstate"
  }
}

provider "aws" {
  region = "ca-central-1"

  default_tags {
    tags = {
      owner      = "otaviofs"
      manager-by = "terraform"
    }
  }
}


provider "azurerm" {
  features {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "otaviofs-remote-state"
    key    = "aws-vpc/terraform.tfstate"
    region = "ca-central-1"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "otaviofsterraformstate"
    container_name       = "romete-state"
    key                  = "azure-vnet/terraform.tfstate"
  }
}