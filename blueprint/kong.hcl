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
      "image.tag" = "latest"
  }
}