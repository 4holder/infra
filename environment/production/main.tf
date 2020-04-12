variable "gcloud_project_id" { default = "fin2you" }

variable "credentials_file" { default = "../../credentials/account.json" }

variable "region" {}
variable "cluster_name" {}
variable "k8s_username" {}
variable "k8s_password" {}

variable "np_services_machine_type" {}
variable "np_services_disk_size_gb" {}
variable "np_services_preemptible" {}
variable "np_services_initial_node_count" {}
variable "np_services_min_node_count" {}
variable "np_services_max_node_count" {}

variable "zone_name" {}
variable "dns_name" {}

terraform {
  backend "gcs" {
    bucket      = "infra_production_terraform"
    prefix      = "production.tfstate"
    credentials = "../../credentials/account.json"
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.gcloud_project_id
  region      = var.region
}

module "cluster_vpc" {
  source                      = "./../../modules/vpc"
  gcloud_project_id           = var.gcloud_project_id
  gcloud_region               = var.region
  credentials_file            = var.credentials_file
}

module "gke_cluster" {
  source                      = "./../../modules/gke"
  gke_cluster_name            = var.cluster_name
  gcloud_project_id           = var.gcloud_project_id
  gcloud_region               = var.region
  credentials_file            = var.credentials_file
  k8s_username                = var.k8s_username
  k8s_password                = var.k8s_password

  services_preemptible        = var.np_services_preemptible
  services_initial_node_count = var.np_services_initial_node_count
  services_disk_size_gb       = var.np_services_disk_size_gb
  services_machine_type       = var.np_services_machine_type
  services_min_node_count     = var.np_services_min_node_count
  services_max_node_count     = var.np_services_max_node_count

  vpc_network                 = module.cluster_vpc.for_holder_production_vpc_network
}

module "for_holder_com_zone" {
  source            = "./../../modules/gcp_zone"
  credentials_file  = var.credentials_file
  gcloud_project_id = var.gcloud_project_id
  gcloud_region     = var.region

  zone_name         = var.zone_name
  dns_name          = var.dns_name
}
