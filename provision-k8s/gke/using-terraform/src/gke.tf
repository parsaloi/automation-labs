# Resource for creating a Google Kubernetes Engine cluster
resource "google_container_cluster" "k8s_cluster" {
  name     = "k8s-cluster-name"
  location = "us-central1-c"

  # Node configuration
  node_config {
    machine_type = "n1-standard-2"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/cloud.platform"
    ]
    image_type = "COS"
    local_ssd_count = 0
  }

  initial_node_count = 3
  min_master_version = "1.30.6-gke.1596000"

  # Autoscaling configuration for the default node pool
  node_pool {
    name       = "default-pool"
    autoscaling {
      min_node_count = 2
      max_node_count = 6
    }
  }
}
