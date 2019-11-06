# Google Cloud connection & authentication and Application configuration | variables-auth.tf

variable "gcp_auth_file" {
  type = string
  description = "GCP authentication file"
}

variable "app_project" {
  type = string
  description = "GCP project name"
}

variable "app_name" {
  type = string
  description = "Application name"
}

variable "app_domain" {
  type = string
  description = "Application domain"
}

variable "app_environment" {
  type = string
  description = "Application environment"
}
