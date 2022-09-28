
terraform {
  required_version = ">= 0.12.23"
  required_providers {
    azurerm = "=2.94.0"
  }
}

data "azurerm_subscription" "current" {
}
data "azuread_client_config" "current" {}

resource "google_container_azure_client" "this" {
  name           = "${var.anthos_prefix}-azure-client"
  location       = var.location
  tenant_id      = var.tenant_id
  application_id = var.application_id
}

resource "azuread_application_certificate" "aad_app_azure_client_cert" {
  application_object_id = var.application_object_id
  type                  = "AsymmetricX509Cert"
  value                 = module.azure_client.certificate
  end_date_relative     = "8760h"
}

resource "time_sleep" "wait_for_aad_app_azure_client_cert" {
  create_duration = "60s"
  depends_on      = [azuread_application_certificate.aad_app_azure_client_cert]
}
