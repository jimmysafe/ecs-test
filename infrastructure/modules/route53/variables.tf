variable "domain" {
  type        = string
  description = "Domain of project. e.g. app.example.com or example.com"
}

variable "lb_dns_name" {
    type        = string
    description = "Load Balancer DNS Name"
}

variable "lb_zone_id" {
    type        = string
    description = "Load Balancer Zone ID"
}
