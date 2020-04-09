provider "google" {
  credentials = file(var.credentials_file)
  project     = var.gcloud_project_id
  region      = var.gcloud_region
}

resource "google_compute_network" "for_holder_production_vpc_network" {
  name = "for-holder-production-vpc-network"
}

