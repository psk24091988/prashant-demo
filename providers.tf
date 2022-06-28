provider "google" {
  project = var.project_id
  credentials = var.creds
  region  = var.region
  }

terraform {
  backend "gcs" {
    bucket = "prashant-terra-buck"
    prefix = "terraform/tfstat"
    force_destroy = false    
  }
}

provider "google-beta" {
    credentials = var.creds
  project     = var.project_id
  region      = var.region
}
