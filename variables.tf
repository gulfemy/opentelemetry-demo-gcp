variable "project_id" {
  description = "GCP project ID"
  type        = string
  default = "phonic-weaver-443009-m8"
}

variable "region" {
  description = "Region for GKE"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "otel-demo-gke"
}

