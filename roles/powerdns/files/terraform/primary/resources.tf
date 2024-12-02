
locals {
  flattened_dns_records = flatten([
    for zone_record in var.dns_records : [
      for record in zone_record.records : {
        zone   = zone_record.zone
        name   = record.name
        type   = record.type
        ttl    = record.ttl
        values = record.records
      }
    ]
  ])
}

# Add a zone
resource "powerdns_zone" "zones" {
  for_each = {
    for zone in var.zones:  zone => "${zone}."
  }
  name         = each.value
  soa_edit_api = "DEFAULT"
  kind         = var.kind
  masters      = var.masters != null ? var.masters : []
  nameservers  = ["ns1.${each.value}", "ns2.${each.value}"]
}

resource "powerdns_record" "dns_records" {
  for_each = { for idx, record in local.flattened_dns_records : "${record.zone}-${record.name}" => record }

  zone    = "${each.value.zone}."
  name    = "${each.value.name}."
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.values
  depends_on = [powerdns_zone.zones]
}
