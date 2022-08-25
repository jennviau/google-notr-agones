resource "google_project_service" "project" {
  for_each = toset(var.list_of_services)

  project                    = var.project_id
  service                    = each.value
  disable_dependent_services = true
}

module "agones-cluster" {
  source = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-cluster?ref=v16.0.0"

  project_id               = var.project_id
  name                     = var.gke_cluster_name
  location                 = var.location
  network                  = var.vpc_network
  subnetwork               = var.vpc_subnetwork
  secondary_range_pods     = null
  secondary_range_services = null

  labels = {
    demo = "google-notr-agones"
  }

  depends_on = [
    google_project_service.project
  ]
}

module "agones-cluster-nodepool" {
  source = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-nodepool?ref=v16.0.0"

  project_id         = var.project_id
  cluster_name       = module.agones-cluster.name
  location           = var.location
  name               = format("%s-nodepool", module.agones-cluster.name)
  initial_node_count = var.gke_initial_node_count
  node_machine_type  = var.gke_node_type
  node_preemptible   = true
}

module "gke-hub" {
  source = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-hub?ref=v16.0.0"

  project_id = var.project_id

  member_clusters = {
    agones-cluster = module.agones-cluster.id
  }

  member_features = {
    configmanagement = {
      binauthz = true
      config_sync = {
        gcp_service_account_email = null
        https_proxy               = null
        policy_dir                = "configsync"
        secret_type               = "none"
        source_format             = "unstructured"
        sync_branch               = "main"
        sync_repo                 = var.configsync_repo
        sync_rev                  = null
      }
      hierarchy_controller = null
      policy_controller    = null
      version              = "1.12.2"
    }
  }
}