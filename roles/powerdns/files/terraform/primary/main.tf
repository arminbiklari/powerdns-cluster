terraform {
  required_providers {
    powerdns = {
      source = "pan-net/powerdns"
      version = "1.5.0"
    }
  }
}

# Configure the PowerDNS provider
provider "powerdns" {
  api_key    = "${var.pdns_api_key}"
  server_url = "${var.pdns_server_url}"
}

terraform {
  backend "http" {}
}
