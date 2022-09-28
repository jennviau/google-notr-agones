variable "configsync_repo" {
  description = "URL of repository to use for Config Sync"
  type        = string
}
variable "admin_users" {
  description = "User to get default Admin RBAC"
  type        = list(string)
}
variable "gcp_location" {
  description = "Zone or Region used for the cluster."
  type        = string
  default     = "us-east1-b"
}
variable "project_id" {
  description = "Project ID cluster is deployed to."
  type        = string
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

variable "gke_cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
  default     = "agones-gcp-cluster"
}

variable "gke_node_type" {
  description = "Node type for the cluster."
  type        = string
  default     = "e2-medium"
}

variable "gke_initial_node_count" {
  description = "Initial number of nodes in the cluster."
  type        = number
  default     = 3
}
variable "gcp_vpc_network" {
  description = "Name or self link of the VPC used for the cluster."
  type        = string
  default     = "default"
}

variable "gcp_vpc_subnetwork" {
  description = "Name or self link of the subnetwork used for the cluster."
  type        = string
  default     = "default"
}

variable "azure_region" {
  description = "Azure region to deploy to"
  type        = string

}



variable "name_prefix" {
  description = "prefix of all artifacts created and cluster name"
  type        = string
}

# This step sets up the default RBAC policy in your cluster for a Google
# user so you can login after cluster creation



variable "azure_node_pool_instance_type" {
  description = "Azure instance type for node pool"
  type        = string
}

variable "azure_control_plane_instance_type" {
  description = "Azure instance type for control plane"
  type        = string
}



# This step sets up the default RBAC policy in your cluster for a Google
# user so you can login after cluster creation




variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
}

#You will need 3 AZs, one for each control plane node
variable "aws_subnet_availability_zones" {
  description = "Availability zones to create subnets in, np will be created in the first"
  type        = list(string)
}

# Use the following command to identify the correct GCP location for a given AWS region
#gcloud container aws get-server-config --location [gcp-region]



variable "aws_vpc_cidr_block" {
  description = "CIDR block to use for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_cp_private_subnet_cidr_blocks" {
  description = "CIDR blocks to use for control plane private subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]
}

variable "aws_np_private_subnet_cidr_blocks" {
  description = "CIDR block to use for node pool private subnets"
  type        = list(string)
  default = [
    "10.0.4.0/24"
  ]
}

#Refer to this page for information on public subnets
#https://cloud.google.com/anthos/clusters/docs/multi-cloud/aws/how-to/create-aws-vpc#create-sample-vpc

variable "aws_public_subnet_cidr_block" {
  description = "CIDR blocks to use for public subnets"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}


variable "aws_pod_address_cidr_blocks" {
  description = "CIDR Block to use for pod subnet"
  type        = string
  default     = "10.2.0.0/16"
}

variable "aws_service_address_cidr_blocks" {
  description = "CIDR Block to use for service subnet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "aws_node_pool_instance_type" {
  description = "AWS Node instance type"
  type        = string
}

variable "control_plane_instance_type" {
  description = "AWS Node instance type"
  type        = string
}
