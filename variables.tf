variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "web_app_name" {
  type = string
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "storage_quota" {
  type    = number
  default = 50
}

variable "service_plan_sku" {
  type    = string
  default = "B1"
}

variable "docker_image" {
  type    = string
  default = "louislam/uptime-kuma:latest"
}
