k8s_config "keycloak" {
  cluster          = "k8s_cluster.k8s"
  paths            = ["./keycloak/"]
  wait_until_ready = true

  health_check {
    timeout = "300s"
    pods    = ["app=keycloak"]
  }
}

ingress "keycloak" {
  source {
    driver = "local"

    config {
      port = 8080
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster         = "k8s_cluster.k8s"
      address         = "keycloak.default.svc"
      port            = 8080
      open_in_browser = "/"
    }
  }
}

exec_remote "keycloak_config" {
  depends_on = ["k8s_config.keycloak"]

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
    value = "${shipyard_ip()}:8080"
  }

}
