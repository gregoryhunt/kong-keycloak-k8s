k8s_config "helloworld" {
  cluster          = "k8s_cluster.k8s"
  paths            = ["./apps/"]
  wait_until_ready = true
}
