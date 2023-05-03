# Datadog GCP Logs Proxy

A workaround to enable Datadog log collection for organizations using GCP w/ VPC service controls

---

### What is this?

The [Datadog procedure for how to collect logs from Google Cloud Platform](https://docs.datadoghq.com/integrations/google_cloud_platform/#log-collection)
does not currently work for organizations that
have [VPC service controls](https://cloud.google.com/vpc-service-controls) enabled due to
a [documented limitation of Pub/Sub push subscriptions](https://cloud.google.com/pubsub/docs/push#vpc-service-control).

This repo is a Terraform module to create a few resources in GCP that should work around the problem described
above. The GCP resources created are

- a Cloud Run service to run [Envoy](https://www.envoyproxy.io/) as a reverse HTTP proxy
    - Uses the [official docker image](https://hub.docker.com/r/envoyproxy/envoy)
- a Service Account to run the Cloud Run service and authenticate btw Pub/Sub and Cloud Run
- a Pub/Sub Topic to collect logs via a [log sink](https://cloud.google.com/logging/docs/routing/overview#sinks)
- a Pub/Sub Subscription to push logs to the Envoy proxy

### How does this work?

This is really nothing special, just a reverse HTTP proxy to get around a GCP limitation. The flow is:

```Pub/Sub subscription <-> Cloud Run Envoy Proxy <-> Datadog Logs API```

The only additional functionality enabled by this workaround is GZIP compression btw the proxy and Datadog.

### How do I use this?

- Make sure you're authenticated via [gcloud](https://cloud.google.com/sdk/gcloud/reference/auth/login)
- Modify `defaults.tfvars`

| Variable            | Description                                                                                                                |
|---------------------|----------------------------------------------------------------------------------------------------------------------------|
| `gcp_region`        | The region for the created resources                                                                                       |
| `gcp_project`       | The name of the project                                                                                                    |
| `resource_prefix`   | The prefix used for all resource names                                                                                     |
| `datadog_logs_host` | The Datadog Logs API hostname (see: https://docs.datadoghq.com/integrations/google_cloud_platform/#log-collection)         |
| `datadog_api_key`   | The Datadog API Key (**TODO:** this key will be visible in the YAML of the Cloud Run service, could be pulled from secret) |

- Run `terraform init`
- Run `terraform apply -var-file=defaults.tfvars`
- Set up a [log sink](https://cloud.google.com/logging/docs/export/configure_export_v2#creating_sink), pointing at the
  Pub/Sub topic created above
    - **NOTE:** it is **highly** recommended you provide
      an [inclusion filter](https://cloud.google.com/logging/docs/export/configure_export_v2#filter-examples), otherwise
      you could be collecting tons of irrelevant logs and paying high costs for GCP and Datadog

### Questions / Comments

[ashraf.hanafy@datadoghq.com](mailto:ashraf.hanafy@datadoghq.com)
<br/>
[ricky.thomas@datadoghq.com](mailto:ricky.thomas@datadoghq.com)
<br/>
[sabbir.muhit@datadoghq.com](mailto:sabbir.muhit@datadoghq.com)
