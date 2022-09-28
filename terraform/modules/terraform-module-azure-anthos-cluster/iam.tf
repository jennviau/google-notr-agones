

#Create an Azure Active Directory application
#https://cloud.google.com/anthos/clusters/docs/multi-cloud/azure/how-to/create-azure-ad-application
resource "azuread_application" "aad_app" {
  display_name = var.application_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "aad_app" {
  application_id               = azuread_application.aad_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# principal to have permission for role assignment.
#https://cloud.google.com/anthos/clusters/docs/multi-cloud/azure/how-to/create-azure-role-assignments

resource "azurerm_role_assignment" "user_access_admin" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "User Access Administrator"
  principal_id         = azuread_service_principal.aad_app.object_id
}
resource "azurerm_role_assignment" "key_vaule_admin" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azuread_service_principal.aad_app.object_id
}
resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aad_app.object_id
}

resource "azurerm_role_assignment" "aad_app_contributor" {
  scope                = azurerm_resource_group.cluster.id
  role_definition_name = "Contributor"
  principal_id         = var.sp_obj_id
}

resource "azurerm_role_assignment" "aad_app_user_admin" {
  scope                = azurerm_resource_group.cluster.id
  role_definition_name = "User Access Administrator"
  principal_id         = var.sp_obj_id
}

resource "azurerm_role_assignment" "aad_app_keyvault_admin" {
  scope                = azurerm_resource_group.cluster.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.sp_obj_id
}

resource "azurerm_role_definition" "this" {
  name        = "${var.aad_app_name}-role-admin"
  scope       = data.azurerm_subscription.current.id
  description = "Allow Anthos service to manage role definitions."

  permissions {
    actions = [
      "Microsoft.Authorization/roleDefinitions/read",
      "Microsoft.Authorization/roleDefinitions/write",
      "Microsoft.Authorization/roleDefinitions/delete",
    ]
    not_actions = [
    ]
  }
  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource "azurerm_role_assignment" "this" {
  scope = azurerm_resource_group.vnet.id
  # See bug https://github.com/hashicorp/terraform-provider-azurerm/issues/8426
  # role_definition_id = azurerm_role_definition.this.id does not work
  role_definition_id = trimsuffix(azurerm_role_definition.this.id, "|${azurerm_role_definition.this.scope}")
  principal_id       = var.sp_obj_id
}

resource "azurerm_role_definition" "vnet" {
  name        = "${var.aad_app_name}-vnet-admin"
  scope       = data.azurerm_subscription.current.id
  description = "Allow Anthos service to use and manage virtual network and role assignments"

  permissions {
    actions = [
      "*/read",
      "Microsoft.Network/*/join/action",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.Authorization/roleAssignments/write",
      "Microsoft.Authorization/roleAssignments/delete",
    ]
    not_actions = [
    ]
  }
  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource "azurerm_role_assignment" "aad_app_vnet" {
  scope = azurerm_virtual_network.vnet.id
  # See bug https://github.com/hashicorp/terraform-provider-azurerm/issues/8426
  # role_definition_id = azurerm_role_definition.vnet.id does not work
  role_definition_id = trimsuffix(azurerm_role_definition.vnet.id, "|${azurerm_role_definition.vnet.scope}")
  principal_id       = var.sp_obj_id
}
