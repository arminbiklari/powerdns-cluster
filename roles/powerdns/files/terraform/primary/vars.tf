variable kind {
  type        = string
  default     = ""
  description = "kind of zones"
}

variable zones {
  type        = list(string)
  description = "zone domain"
  default = []
}

variable "masters" {
  type = list(string)
  default = []
}

variable "pdns_api_key" {
  type = string
}

variable "pdns_server_url" {
  type = string
}

variable "dns_records" {
  description = "DNS records per zone"
  type        = list(object({
    zone    = string
    records = list(object({
      name    = string
      type    = string
      ttl     = number
      records = list(string)
    }))
  }))
}

