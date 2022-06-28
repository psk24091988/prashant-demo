provider "google" {
  project = var.project_id
  credentials = var.creds
  region  = var.region
  }

provider "google-beta" {
    credentials = var.creds
  project     = var.project_id
  region      = var.region
}
