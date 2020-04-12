output "zone_name" {
  value = google_dns_managed_zone.forholder_com.name
}

output "dns_zone" {
  value = google_dns_managed_zone.forholder_com.dns_name
}
