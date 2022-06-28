resource "google_storage_bucket" "prashant-terra-buck"  {
  name = "prashant-terra-buck"
  prefix = "terraform/tfstat"
  force_destroy = false
  location      = var.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}
