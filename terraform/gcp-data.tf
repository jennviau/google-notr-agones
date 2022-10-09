module "gcp_data" {
  source       = "./modules/gcp_data"
  gcp_location = var.gcp_location
  gcp_project  = var.gcp_project_id
}