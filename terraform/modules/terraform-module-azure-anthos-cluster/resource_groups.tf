



resource "azurerm_resource_group" "cluster" {
  name     = var.name
  location = var.region
}
resource "azurerm_resource_group" "vnet" {
  location = var.region
  name     = var.name
}

#Create Azure role assignments
#https://cloud.google.com/anthos/clusters/docs/multi-cloud/azure/how-to/create-azure-role-assignments

