# resource "google_project_service" "project" {
#   for_each = toset(var.list_of_services)

#   project                    = var.project_id
#   service                    = each.value
#   disable_dependent_services = true
# }

module "agones-gcp-cluster" {
  source = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-cluster?ref=v18.0.0"

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

  # depends_on = [
  #   google_project_service.project
  # ]
}

module "agones-gcp-cluster-nodepool" {
  source = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-nodepool?ref=v18.0.0"

  project_id         = var.project_id
  cluster_name       = module.agones-gcp-cluster.name
  location           = var.location
  name               = format("%s-nodepool", module.agones-gcp-cluster.name)
  initial_node_count = var.gke_initial_node_count
  node_machine_type  = var.gke_node_type
  node_preemptible   = true
  node_tags          = ["google-notr-agones"]
}

