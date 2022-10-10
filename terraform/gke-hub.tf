module "gke-hub" {
  source = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/gke-hub?ref=v18.0.0"

  project_id = var.project_id

 clusters = {
    demo-agones-gcp-cluster = module.agones-gcp-cluster.id
  }

 features = {
    appdevexperience             = false
    configmanagement             = true
    identityservice              = false
    multiclusteringress          = null
    servicemesh                  = false
    multiclusterservicediscovery = false
  }
    configmanagement_templates = {
      default = {
        binauthz = true
        config_sync = {
            git = {
              gcp_service_account_email = null
              https_proxy               = null
              policy_dir                = "configsync"
              secret_type               = "none"
              source_format             = "unstructured"
              sync_branch               = "main"
              sync_repo                 = var.configsync_repo
              sync_rev                  = null
              sync_wait_secs            = null

            }
          prevent_drift = false
          source_format = "unstructured"
        }
      hierarchy_controller = null
      policy_controller    = null
      version              = "1.12.2"
    }
  }
    configmanagement_clusters = {
    "default" = [ "demo-agones-gcp-cluster"]
  }

  depends_on = [
    module.agones-gcp-cluster-nodepool,

  ]
}