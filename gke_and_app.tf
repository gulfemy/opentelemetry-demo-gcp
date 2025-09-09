# Create a VPC without auto subnet creation
resource "google_compute_network" "vpc_network" {
  name                    = "otel-demo-vpc"
  auto_create_subnetworks = false
  description             = "VPC for OpenTelemetry GKE demo with custom regional subnet"
}

# Create a subnet in the specific region (e.g., us-central1)
resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "otel-demo-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  description   = "Subnet for OpenTelemetry demo in region ${var.region}"
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  deletion_protection = false
  initial_node_count = 1

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.vpc_subnet.name

  node_config {
    machine_type = "e2-standard-4"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}


resource "kubernetes_namespace" "otel_demo" {
  metadata {
    name = "otel-demo"
  }
}

resource "helm_release" "opentelemetry_demo" {
  name       = "otel-demo"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-demo"
  namespace  =  kubernetes_namespace.otel_demo.metadata[0].name
}
