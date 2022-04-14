k8s_config "keycloak" {
  cluster          = "k8s_cluster.k8s"
  paths            = ["./keycloak/"]
  wait_until_ready = true

  health_check {
    timeout = "300s"
    pods    = ["app=keycloak"]
  }
}

k8s_ingress "keycloak" {
  depends_on = ["k8s_config.keycloak"]

  cluster = "k8s_cluster.k8s"

  network {
    name = "network.local"
  }

  deployment = "keycloak-deployment"

  port {
    local           = 8080
    remote          = 8080
    host            = 8080
    open_in_browser = "/"
  }

}

exec_remote "keycloak_config" {
  depends_on = ["k8s_ingress.keycloak"]

  image {
    name = "rancher/curl"
  }

  network {
    name = "network.local"
  }

  cmd = "/scripts/keycloak-config.sh"

  volume {
    source      = "./keycloak/scripts"
    destination = "/scripts"
  }

  env {
    key   = "KEYCLOAK_URL"
    value = "http://keycloak.ingress.shipyard.run:8080"
  }

}
