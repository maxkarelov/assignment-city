terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

# Create a Kubernetes cluster
resource "digitalocean_kubernetes_cluster" "kubernetes_cluster" {
  name    = "${var.k8s_cluster_name}-${var.env}"
  region  = var.region
  version = var.kubernetes_version

  node_pool {
    name       = "worker-pool"
    size       = var.k8s_node_size
    auto_scale = true
    min_nodes  = var.k8s_min_nodes
    max_nodes  = var.k8s_max_nodes
  }
}

# Create a database cluster for OpenSearch
resource "digitalocean_database_cluster" "opensearch" {
  name                 = "opensearch-${var.env}"
  engine              = "opensearch"
  version             = "2"
  size                = var.db_size
  region              = var.region
  node_count          = var.db_node_count
}
