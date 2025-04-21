
# Output the cluster's kubeconfig
output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.kubernetes_cluster.kube_config[0].raw_config
  sensitive = true
}

# Output the database connection details
output "database_host" {
  value = digitalocean_database_cluster.opensearch.host
}

output "database_port" {
  value = digitalocean_database_cluster.opensearch.port
}

output "database_user" {
  value = digitalocean_database_cluster.opensearch.user
}

output "database_password" {
  value     = digitalocean_database_cluster.opensearch.password
  sensitive = true
}
