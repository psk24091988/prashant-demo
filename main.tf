module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  region                     = var.region
  zones                      = var.zones
  name                       = var.name
  network                    = "default"
  subnetwork                 = "default"
  ip_range_pods              = ""
  ip_range_services          = ""
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  #kubernetes_dashboard       = true#
  network_policy             = true

  node_pools = [
    {
      name               = var.name
      machine_type       = var.machine_type
      min_count          = var.min_count
      max_count          = var.max_count
      disk_size_gb       = var.disk_size_gb
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = var.service_account
      preemptible        = false
      initial_node_count = var.initial_node_count
    },
  ]
}
 
resource "google_container_node_pool" "node_pool" {
  cluster = var.name

  name     = "main-pool"
  project  = var.project_id
  location = var.region
  
  initial_node_count = "1"

  autoscaling {
    min_node_count = "1"
    max_node_count = "5"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    image_type   = "COS"
    machine_type = "n1-standard-1"

    labels = {
      all-pools-example = "true"
    }

    tags = [
      "helm-example",
    ]

    disk_size_gb = "30"
    disk_type    = "pd-standard"
    preemptible  = false

    service_account = var.service_account

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}


resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "gcloud beta container clusters get-credentials ${var.name} --region ${var.region} --project ${var.project_id}"

    environment = {
      KUBECONFIG = "$HOME/.kube/config"
    }
  }

  depends_on = [google_container_node_pool.node_pool]
}

resource "helm_release" "nginx" {
  depends_on = [google_container_node_pool.node_pool]

  repository = "https://charts.bitnami.com/bitnami"
  name       = "nginx"
  chart      = "nginx"
}

  
