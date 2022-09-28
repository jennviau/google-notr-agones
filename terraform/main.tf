terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.33.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }

  }
}

provider "google" {}

provider "azurerm" {
  features {}
}
provider "aws" {
  region = var.aws_region
}
provider "azuread" {
}


resource "tls_private_key" "anthos_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  name_prefix = "${var.name_prefix}-${random_string.suffix.result}"
}
resource "random_string" "suffix" {
  length    = 2
  special   = false
  lower     = true
  min_lower = 2
}

module "gcp_data" {
  source       = "./modules/terraform-module-gcp-data"
  gcp_location = var.gcp_location
  gcp_project  = var.gcp_project_id
}