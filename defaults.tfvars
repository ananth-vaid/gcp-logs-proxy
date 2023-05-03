gcp_region      = "us-east1"
gcp_project     = "my-project"
resource_prefix = "dd-logs-proxy"
datadog_api_key = "dd-api-key"

# See: https://docs.datadoghq.com/integrations/google_cloud_platform/#log-collection
datadog_logs_host = "gcp-intake.logs.datadoghq.com"     # US1
#datadog_logs_host = "gcp-intake.logs.us3.datadoghq.com" # US3
#datadog_logs_host = "gcp-intake.logs.us5.datadoghq.com" # US5
#datadog_logs_host = "gcp-intake.logs.datadoghq.eu"      # EU
#datadog_logs_host = "gcp-intake.logs.ap1.datadoghq.com" # AP1
#datadog_logs_host = "gcp-intake.logs.ddog-gov.com"      # US1-FED
