terraform {
 backend "gcs" {
   bucket  = "notr-2022-anthos-state"
   prefix  = "terraform/state"
 }
}