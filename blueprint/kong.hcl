helm "kong" {
  cluster = "k8s_cluster.k8s"

  repository {
    name = "kong"
    url  = "https://charts.konghq.com"
  }

  chart   = "kong/kong"
  version = "2.7.0"

  values_string = {
    "image.repository" = "shipyard.run/localcache/kong-oidc"
    "image.tag"        = "latest"
  }
}

ingress "kong_80" {
  source {
    driver = "local"

    config {
      port = 10080
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.k8s"
      address = "kong-kong-proxy.default.svc"
      port    = 80
    }
  }
}

ingress "kong_443" {
  source {
    driver = "local"

    config {
      port = 10443
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.k8s"
      address = "kong-kong-proxy.default.svc"
      port    = 443
    }
  }
}