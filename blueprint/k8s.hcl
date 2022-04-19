k8s_cluster "k8s" {

  depends_on = ["container.kong-oidc"]

  driver = "k3s"

  nodes = 1

  network {
    name = "network.local"
  }

  image {
    name = "shipyard.run/localcache/kong-oidc:latest"
  }
}
output "KUBECONFIG" {
  value = k8s_config("k8s")
}
