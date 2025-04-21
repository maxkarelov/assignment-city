variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "fra1"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "k8s_cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "kubernetes-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32.2-do.0"
}

variable "k8s_node_size" {
  description = "Size of the Kubernetes nodes"
  type        = string
  default     = "s-1vcpu-2gb"
}

variable "k8s_min_nodes" {
  description = "Minimum number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "k8s_max_nodes" {
  description = "Maximum number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "db_node_count" {
  description = "OpenSearch node count"
  type        = number
  default     = 1
}

variable "db_size" {
  description = "Size of the database cluster"
  type        = string
  default     = "db-s-1vcpu-2gb"
}
