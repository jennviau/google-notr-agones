variable "configsync_repo" {
  description = "URL of repository to use for Config Sync"
  type        = string
}

variable "gke_cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
  default     = "agones-cluster"
}

variable "gke_node_type" {
  description = "Node type for the cluster."
  type        = string
  default     = "e2-standard-4"
}

variable "gke_initial_node_count" {
  description = "Initial number of nodes in the cluster."
  type        = number
  default     = 3
}

variable "location" {
  description = "Zone or Region used for the cluster."
  type        = string
  default     = "us-east1-b"
}

variable "list_of_services" {
  description = "List of API services to be enabled in the project."
  type        = list(string)
  default = [
    "gkehub.googleapis.com",
    "gkeconnect.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "container.googleapis.com"
  ]
}

variable "project_id" {
  description = "Project ID cluster is deployed to."
  type        = string
}

variable "vpc_network" {
  description = "Name or self link of the VPC used for the cluster."
  type        = string
  default     = "default"
}

variable "vpc_subnetwork" {
  description = "Name or self link of the subnetwork used for the cluster."
  type        = string
  default     = "default"
}