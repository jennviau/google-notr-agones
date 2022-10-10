output "generate_gke_credentials" {
  description = "Connect Instructions"
  value       = format("To connect to your cluster issue the command: \n gcloud container clusters get-credentials %s --zone %s --project %s", var.gke_cluster_name, var.location, var.project_id)
}


output "generate_azure_credentials" {
  description = "Connect Instructions"
  value       = "To connect to your cluster issue the command:\n gcloud container azure clusters get-credentials ${var.name_prefix}"
}


output "generate_aws_credentials" {
  description = "Connect Instructions"
  value       = "To connect to your cluster issue the command:\n gcloud container aws clusters get-credentials ${var.aws_name_prefix}"
}
