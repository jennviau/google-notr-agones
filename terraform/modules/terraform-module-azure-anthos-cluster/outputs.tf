/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "fleet_membership" {
  value = google_container_azure_cluster.this.fleet[0].membership
}
output "resource_group_id" {
  description = "The id of the cluster resource group"
  value       = azurerm_resource_group.cluster.id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.default.id
}

output "subnet_address_prefixes" {
  description = "The address prefixes of the subnet"
  value       = azurerm_subnet.default.address_prefixes
}

output "vnet_id" {
  description = "The ID of the vnet"
  value       = azurerm_virtual_network.vnet.id
}

output "location" {
  description = "The location/region of vnet"
  value       = azurerm_virtual_network.vnet.location
}
output "subscription_id" {
  description = "The ID of the subscription"
  value       = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  description = "The ID of the tenant"
  value       = data.azurerm_subscription.current.tenant_id
}

output "aad_app_id" {
  description = "The id of the aad app registration"
  value       = azuread_application.aad_app.application_id
}

output "aad_app_obj_id" {
  description = "The object id of the aad app registration"
  value       = azuread_application.aad_app.object_id
}

output "aad_app_sp_obj_id" {
  description = "The object id of the aad service principal"
  value       = azuread_service_principal.aad_app.object_id
}

output "certificate" {
  value = google_container_azure_client.this.certificate
}

output "client" {
  value = google_container_azure_client.this.id
}

output "client_name" {
  value = google_container_azure_client.this.name
}

