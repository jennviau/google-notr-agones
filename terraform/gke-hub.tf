module "gke-hub" {
  source = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-hub?ref=v16.0.0"

  project_id = var.project_id

  member_clusters = {
    demo-agones-gcp-cluster = module.agones-gcp-cluster.id
    #demo-agones-azure-cluster = module.agones-azure-cluster.google_container_azure_cluster.this.id
  }

  member_features = {
    configmanagement = {
      binauthz = true
      config_sync = {
        gcp_service_account_email = null
        https_proxy               = null
        policy_dir                = "configsync"
        secret_type               = "ssh"
        source_format             = "hierarchy"
        sync_branch               = "main"
        sync_repo                 = var.configsync_repo
        sync_rev                  = null
      }
      hierarchy_controller = null
      policy_controller    = null
      version              = "1.12.2"
    }
  }

  depends_on = [
    module.agones-gcp-cluster-nodepool,
    module.agones-azure-cluster
  ]
}