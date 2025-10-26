variable "project_name" {
  type    = string
  default = "portfolio"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "repository_name" {
  type    = string
  default = "app"
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type    = string
  default = "us-west1"
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "enable_lifecycle_policy" {
  type    = bool
  default = true
}

variable "image_retention_count" {
  type    = number
  default = 10
}

variable "tags" {
  type    = map(string)
  default = {}
}
