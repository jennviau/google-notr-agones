





module "agones-azure-cluster" {
  source                      = "./modules/terraform-module-azure-anthos-cluster"
  gcp_project                 = var.gcp_project_id
  application_name            = "${local.name_prefix}-app"
  resource_group_name         = "${local.name_prefix}-vnet-rg"
  region                      = var.azure_region
  aad_app_name                = "${local.name_prefix}-app"
  sp_obj_id                   = module.aad_app.aad_app_sp_obj_id
  subscription_id             = module.aad_app.subscription_id
  name                        = "${local.name_prefix}-rg"
  azure_region                = var.azure_region
  location                    = var.gcp_location
  cluster_version             = coalesce(var.cluster_version, module.gcp_data.latest_version)
  admin_users                 = var.admin_users
  anthos_prefix               = local.name_prefix
  resource_group_id           = module.cluster_rg.resource_group_id
  subnet_id                   = module.cluster_vnet.subnet_id
  ssh_public_key              = tls_private_key.anthos_ssh_key.public_key_openssh
  project_number              = module.gcp_data.project_number
  virtual_network_id          = module.cluster_vnet.vnet_id
  tenant_id                   = module.aad_app.tenant_id
  control_plane_instance_type = var.control_plane_instance_type
  node_pool_instance_type     = var.node_pool_instance_type
  application_id              = module.aad_app.aad_app_id
  application_object_id       = module.aad_app.aad_app_obj_id
  fleet_project               = "projects/${module.gcp_data.project_number}"

}

module "create_azure_vars" {
  source                = "terraform-google-modules/gcloud/google"
  platform              = "linux"
  create_cmd_entrypoint = "./modules/scripts/create_azure_vars.sh"
  create_cmd_body       = "\"${local.name_prefix}\" \"${var.gcp_location}\" \"${var.azure_region}\" \"${var.cluster_version}\" \"${tls_private_key.anthos_ssh_key.public_key_openssh}\" \"${module.cluster_vnet.subnet_id}\""
  module_depends_on     = [module.agones-azure-cluster]
}

