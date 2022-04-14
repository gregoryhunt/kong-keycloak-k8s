k8s_config "keycloak" {
  cluster          = "k8s_cluster.k8s"
  paths            = ["./keycloak/"]
  wait_until_ready = true

  health_check {
    timeout = "300s"
    pods    = ["app.kubernetes.io/name=keycloak"]
  }
}

k8s_ingress "app" {
  cluster = "k8s_cluster.k8s"

  network {
    name = "network.local"
  }

  deployment = "keycloak"

  port {
    local           = 8080
    remote          = 8080
    host            = 8080
    open_in_browser = "/"
  }

  depends_on = ["k8s_config.keycloak"]
}


k8s_config "helloworld" {
  cluster          = "k8s_cluster.k8s"
  paths            = ["./apps/"]
  wait_until_ready = true
}
