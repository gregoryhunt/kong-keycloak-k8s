container "kong-oidc" {
  build   {
    file = "./Dockerfile"
    context = "./kong-init"
  }


  network {
    name = "network.local"
  }
}