
## Using ExternalDNS with GKE Autopilot

The following script configures the clusters, and gcp projects to use GKE workload identity to provide ExternalDNS with the permissions it needs to manage DNS records. Workload identity is the Google-recommended way to provide GKE workloads access to GCP APIs.

Modify the cluster names, gcp project, domain, and cluster regions variables as needed.

```shell
#!/bin/bash

set -x 

sa_display="Workload Identity Service Account for ExternalDNS"
domain="automateit.ca"
dns_project="swampup-2022"

clusters=(staging-cluster dev-cluster prod-cluster)
declare -A service_accounts=(
  [staging-cluster]=sa-stg-edns
  [dev-cluster]=sa-dev-edns
  [prod-cluster]=sa-prod-edns
)

declare -A gcp_projects=(
  [staging-cluster]=swampup-2022
  [dev-cluster]=swampup-2022
  [prod-cluster]=swampup-2022
)
declare -A cluster_regions=(
  [staging-cluster]=us-central1
  [dev-cluster]=us-central1
  [prod-cluster]=us-central1
)


# Loop through Service Accounts for Dev,Stg,Prod Clusters
for cluster in "${clusters[@]}"; do

# Create a GCP service account (GSA) for ExternalDNS and save its email address.
gcloud iam service-accounts create ${service_accounts[$cluster]} --display-name="${sa_display}"

# Bind the ExternalDNS GSA to the DNS admin role.
gcloud projects add-iam-policy-binding ${dns_project} \
--member="serviceAccount:${service_accounts[$cluster]}@${gcp_projects[$cluster]}.iam.gserviceaccount.com"  \
--role=roles/dns.admin

# Link the ExternalDNS GSA to the Kubernetes service account (KSA) that
# external-dns will run under, i.e., the external-dns KSA in the external-dns
# namespaces.
gcloud iam service-accounts add-iam-policy-binding ${service_accounts[$cluster]}@${gcp_projects[$cluster]}.iam.gserviceaccount.com \
--member="serviceAccount:${gcp_projects[$cluster]}.svc.id.goog[external-dns/${service_accounts[$cluster]}]" \
--role=roles/iam.workloadIdentityUser \
--project=${gcp_projects[$cluster]}


gcloud container clusters get-credentials  ${cluster} --project ${gcp_projects[$cluster]} --region ${cluster_regions[$cluster]}

cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Namespace
metadata:
  name: external-dns
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${service_accounts[$cluster]}
  namespace: external-dns
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: external-dns
rules:
  - apiGroups: [""]
    resources: ["services", "endpoints", "pods"]
    verbs: ["get", "watch", "list"]
  - apiGroups: ["extensions", "networking.k8s.io"]
    resources: ["ingresses"]
    verbs: ["get", "watch", "list"]
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
  - kind: ServiceAccount
    name: ${service_accounts[$cluster]}
    namespace: external-dns
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
  namespace: external-dns
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: external-dns
  template:
    metadata:
      labels:
        app: external-dns
    spec:
      containers:
        - args:
            - --source=ingress
            - --source=service
            - --domain-filter=${domain}
            - --provider=google
            - --google-project=${dns_project}
            - --registry=txt
            - --txt-owner-id=${cluster}
          image: k8s.gcr.io/external-dns/external-dns:v0.8.0
          name: external-dns
      securityContext:
        fsGroup: 65534
        runAsUser: 65534
      serviceAccountName: ${service_accounts[$cluster]}
EOF

kubectl annotate serviceaccount --namespace=external-dns ${service_accounts[$cluster]} \
"iam.gke.io/gcp-service-account=${service_accounts[$cluster]}@${gcp_projects[$cluster]}.iam.gserviceaccount.com"

done
```