resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.region
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = ["10.0.0.0/16", "10.200.0.0/16"]
}

#Create subnet
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#Create Public IP
resource "azurerm_public_ip" "nat_gateway_pip" {
  name                = "${var.name}-nat-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.vnet.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Create NAT Gateway

resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "${var.name}-nat-gateway"
  location                = var.region
  resource_group_name     = azurerm_resource_group.vnet.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

# associate public IP with NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_gateway" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip.id
}

# associate  NAT Gateway with subnet
resource "azurerm_subnet_nat_gateway_association" "default_subnet_nat_association" {
  subnet_id      = azurerm_subnet.default.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
