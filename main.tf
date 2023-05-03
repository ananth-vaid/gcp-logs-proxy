terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.63.1"
    }
  }
  required_version = "~> 1.4.0"
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}

data "google_client_config" "current" {
}

resource "google_cloud_run_v2_service" "service" {
  location = data.google_client_config.current.region
  project  = data.google_client_config.current.project

  name = "${var.resource_prefix}-service"

  template {
    service_account = google_service_account.account.email

    containers {
      image = "envoyproxy/envoy:distroless-v1.26-latest"
      args  = [
        "--config-yaml",
        templatefile(
          "${path.module}/templates/envoy.tftpl.yaml",
          {
            datadog_logs_host = var.datadog_logs_host,
            datadog_api_key   = var.datadog_api_key
          }
        )
      ]
    }
  }
}

resource "google_service_account" "account" {
  project = data.google_client_config.current.project

  account_id   = "${var.resource_prefix}-account"
  display_name = "Service account for Datadog Logs proxy"
}

resource "google_cloud_run_v2_service_iam_binding" "role" {
  location = data.google_client_config.current.region
  project  = data.google_client_config.current.project

  name = google_cloud_run_v2_service.service.name

  role    = "roles/run.invoker"
  members = [format("serviceAccount:%s", google_service_account.account.email)]
}

resource "google_pubsub_topic" "topic" {
  project = data.google_client_config.current.project

  name = "${var.resource_prefix}-topic"
}

resource "google_pubsub_subscription" "subscription" {
  project = data.google_client_config.current.project

  name  = "${var.resource_prefix}-sub"
  topic = google_pubsub_topic.topic.name

  push_config {
    push_endpoint = google_cloud_run_v2_service.service.uri
    oidc_token {
      service_account_email = google_service_account.account.email
    }
  }
}
