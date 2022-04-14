k8s_cluster "k8s" {
  driver = "k3s"

  nodes = 1

  network {
    name = "network.local"
  }
}
output "KUBECONFIG" {
  value = k8s_config("k8s")
}
