# Google Cloud: Next on the Road 
This repository contains all the code used in the `Reliable, Repeatable, and Scalable Multi-cloud Application deployments with Anthos` talk at **Google Cloud: Next on the Road**

## Goals
This demo showcases how to use Anthos Config Management (ACM), specifically Config Sync, to deploy consistent configuration across Kubernetes clusters. These clusters can be in a single Cloud environment or span hybrid and multi-cloud environments.

All the infrastructure is stood up using Terraform. Once Terraform completes, ACM takes over to roll-out ArgoCD, Agones, cert-manager, and an NGINX ingress controller in all Kubernetes clusters spanning multiple clouds simultaneously.

## Set Up
This demo requires that you have access to a GCP project with the following APIs enabled:
- GKE Hub API
- Anthos Config Management API
- GKE Connect API
- Kubernetes Engine API

## Deployment
Create a `terraform.tfvars` (Use the sample as a starting point)
```bash
cp terraform.tfvars.sample terraform.tfvars
```

Initalize Terraform to download all necessary modules and providers and initalize the backend.
```bash
terraform init
```

Apply the Terraform code to deploy a GKE and AKS cluster along with registering them with ACM to bootstrap the clusters with Agones.
```bash
terraform apply
```

## Validate Deployment Status
Google provides a CLI tool called `nomos` which can be used to validate the status of Config Sync and ensure it has consolidated and applied the configuration successfully. `nomos` uses your kubeconfig to discover and authenticate against your clusters.

### Retrieve GKE Credentials
```bash
gcloud container clusters get-credentials agones-cluster
```

### Retrieve AKS Credentials
```bash

```

### Using Nomos
```bash
nomos status
```

## Accessing Gameservers
Once your cluster is synced, you can view your gameservers:
```bash
kubectl get gameservers
```

> output

```bash

```

Download the [Minetest](https://www.minetest.net/downloads/) client and launch it.

Enter an IP address and port number and click `Register`.
![Homescreen](images/homescreen.png)

Fill in a `Name` and `Password` and click `Register` to be launched into the game.
![Launch](images/register.png)