



module "aad_app" {
  source = "./modules/aad-app"

  #gcp_project      = var.gcp_project_id
  application_name = "${local.name_prefix}-app"
}

module "cluster_vnet" {
  source = "./modules/cluster-vnet"

  name            = "${local.name_prefix}-vnet-rg"
  region          = var.azure_region
  aad_app_name    = "${local.name_prefix}-app"
  sp_obj_id       = module.aad_app.aad_app_sp_obj_id
  subscription_id = module.aad_app.subscription_id
  depends_on = [
    module.aad_app
  ]
  # create_proxy = var.create_proxy
}

module "cluster_rg" {
  source    = "./modules/cluster-rg"
  name      = "${local.name_prefix}-rg"
  region    = var.azure_region
  sp_obj_id = module.aad_app.aad_app_sp_obj_id
  depends_on = [
    module.aad_app
  ]
}
module "agones-azure-cluster" {
  source                      = "./modules/azure_anthos_cluster"
  azure_region                = var.azure_region
  location                    = var.gcp_location
  cluster_version             = coalesce(var.cluster_version, module.gcp_data.latest_version)
  admin_users                 = var.admin_users
  anthos_prefix               = var.name_prefix
  anthos_client_prefix        = local.name_prefix
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
  depends_on = [
    module.aad_app, module.cluster_rg, module.cluster_vnet
  ]
}

module "create_azure_vars" {
  source                = "terraform-google-modules/gcloud/google"
  platform              = "linux"
  create_cmd_entrypoint = "./modules/scripts/create_vars.sh"
  create_cmd_body       = "\"${local.name_prefix}\" \"${var.gcp_location}\" \"${var.azure_region}\" \"${var.cluster_version}\" \"${tls_private_key.anthos_ssh_key.public_key_openssh}\" \"${module.cluster_vnet.subnet_id}\""
  module_depends_on     = [module.agones-azure-cluster]
}
