resource "google_container_cluster" "gke" {
  name               = var.gke_cluster_name
  location           = var.gcloud_region

  node_locations = [
    "${var.gcloud_region}-a"
  ]

  network = var.vpc_network

  initial_node_count = 1
  remove_default_node_pool = true

  enable_legacy_abac = true

  master_auth {
    username = var.k8s_username
    password = var.k8s_password
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = true
    }
  }
}

resource "google_container_node_pool" "services_node_pool" {
  name       = "services-node-pool"
  location   = var.gcloud_region
  cluster    = google_container_cluster.gke.name
  node_count = var.services_initial_node_count

  node_config {
    preemptible  = var.services_preemptible
    machine_type = var.services_machine_type
    disk_size_gb = var.services_disk_size_gb

    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]

    labels = {
      name     = "services-node-pool"
      nodepool = "services-node-pool"
    }
  }

  autoscaling {
    min_node_count = var.services_min_node_count
    max_node_count = var.services_max_node_count
  }
}
