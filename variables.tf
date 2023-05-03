variable "gcp_region" {
  type        = string
  description = "The GCP region to apply changes to"
}

variable "gcp_project" {
  type        = string
  description = "The GCP project to apply changes to"
}

variable "resource_prefix" {
  type        = string
  description = "The prefix to be used in resource names (i.e. Cloud Run, Pub/Sub, IAM, etc)"
}

variable "datadog_logs_host" {
  type        = string
  description = "The Datadog Logs API host"
}

variable "datadog_api_key" {
  type        = string
  description = "The Datadog API key"
}
