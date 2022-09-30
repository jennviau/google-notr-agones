output "generate_gke_credentials" {
    value = format("gcloud container clusters get-credentials %s --zone %s --project %s", var.gke_cluster_name, var.location, var.project_id)
}