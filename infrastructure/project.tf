data "google_project" "project" {
}

resource "google_project_service" "enable" {
  count   = length(local.enabled_apis)
  project = local.project_id
  service = "${element(local.enabled_apis, count.index)}.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

locals {
  #########################################################
  # !!! IMPORTANT!!!: When adding new services to the
  # enabled_apis list, ALWAYS add them to the END.
  # Adding them to the middle will lead to problems.
  #########################################################
  enabled_apis = [
    "bigquery", "bigquerystorage", "cloudkms", "pubsub", "storage-api", "storage-component",
    "storage", "secretmanager", "cloudfunctions", "cloudbuild", "bigqueryconnection", "cloudscheduler",
    "notebooks", "aiplatform", "dataform", "visionai", "compute", "dataflow", "artifactregistry"
  ]
}