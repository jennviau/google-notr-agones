output "generate_gke_credentials" {
  value = format("gcloud container clusters get-credentials %s --zone %s --project %s", var.gke_cluster_name, var.location, var.project_id)
}
output "azure_cluster_name" {
  description = "The automatically generated name of your Azure GKE cluster"
  value       = var.name_prefix
}
output "vars_file" {
  description = "The variables needed to create more node pools are in the vars.sh file.\n If you create additional node pools they must be manually deleted before you run terraform destroy"
  value       = "vars.sh"
}
output "vnet_resource_group" {
  description = "VNET Resource Group"
  value       = "${local.name_prefix}-vnet-rg"
}

output "cluster_resource_group" {
  description = "VNET Resource Group"
  value       = "${local.name_prefix}-rg"
}

output "message" {
  description = "Connect Instructions"
  value       = "To connect to your cluster issue the command:\n gcloud container azure clusters get-credentials ${var.name_prefix}"
}
