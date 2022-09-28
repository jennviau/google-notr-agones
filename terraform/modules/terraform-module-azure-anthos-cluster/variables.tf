

variable "project_number" {
}
variable "location" {
}
variable "azure_region" {
}
variable "resource_group_id" {
}
variable "admin_users" {
  type = list(string)
}
variable "cluster_version" {
}
variable "node_pool_instance_type" {
}
variable "control_plane_instance_type" {
}
variable "subnet_id" {
}
variable "ssh_public_key" {
}
variable "virtual_network_id" {
}
variable "pod_address_cidr_blocks" {
  default = ["10.200.0.0/16"]
}
variable "service_address_cidr_blocks" {
  default = ["10.32.0.0/24"]
}
variable "anthos_prefix" {
}

variable "application_id" {
}
variable "application_object_id" {
}
variable "fleet_project" {
}
variable "name" {
  description = "Name for the test cluster"
  type        = string
}

variable "region" {
  description = "Azure region to deploy to"
  type        = string
}





variable "aad_app_name" {
  description = "app registration name"
  type        = string
}
variable "sp_obj_id" {
  description = "app service principal object id"
  type        = string
}
variable "subscription_id" {
  description = "subscription_id "
  type        = string
}
variable "application_name" {
  description = "Name of the Azure application to create: ex: GCP-Anthos"
  type        = string
}


