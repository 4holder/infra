output "client_certificate" {
  value = module.gke_cluster.client_certificate
  sensitive = true
}

output "client_key" {
  value = module.gke_cluster.client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value = module.gke_cluster.cluster_ca_certificate
  sensitive = true
}

output "endpoint" {
  value = module.gke_cluster.endpoint
  sensitive = true
}

output "dns_zone" {
  value = module.for_holder_com_zone.dns_zone
}

output "zone_name" {
  value = module.for_holder_com_zone.zone_name
}
