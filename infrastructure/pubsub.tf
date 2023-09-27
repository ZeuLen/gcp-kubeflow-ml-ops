##################################################################################################
# Retail Media Vertex AI pipeline trigger topic
# The destination topic for the cloud scheduler that triggers the Retail Media Vertex AI Pipeline
##################################################################################################

resource "google_pubsub_topic" "rm-vertex-pipeline-trigger-topic" {
  name = "rm-vertex-pipeline-trigger-topic"
}


#####################################################################################
# Retail Media Vertex AI pipeline trigger cloud scheduler
# The cloud scheduler triggering the  Retail Media Vertex AI Pipeline Cloud Function
#####################################################################################

locals {
    pipeline_path = split(",", var.pipeline_path)
    pipeline_name = split(",", var.pipeline_name)
    schedule_list = split(",", var.schedule)
}

resource "google_cloud_scheduler_job" "rm-vertex-pipeline-trigger" {
  for_each = {
    for idx, schedule in local.schedule_list : idx => {
      pipeline_name = element(split(",", var.pipeline_name), idx)
      pipeline_path = element(split(",", var.pipeline_path), idx)
      schedule      = schedule
    }
  }

  name        = "rm-vertex-pipeline-trigger-${each.value.pipeline_name}"
  description = each.value.pipeline_name
  schedule    = each.value.schedule
  region      = var.gcp_region
  time_zone   = var.time_zone

  pubsub_target {
    topic_name = google_pubsub_topic.rm-vertex-pipeline-trigger-topic.id
    data       = base64encode(jsonencode({
      project_id    = var.project,
      pipeline_name = each.value.pipeline_name,
      pipeline_path = each.value.pipeline_path,
    }))
  }

  depends_on = [
    google_project_service.enable,
    google_pubsub_topic.rm-vertex-pipeline-trigger-topic
  ]
}



###############################
# Pub/Sub for Pipeline Alerting
###############################

resource "google_pubsub_topic" "vertex_pipeline_alerting_topic" {
  name = "vertex_pipeline_alerting_topic"
}

resource "google_cloud_scheduler_job" "vertex_pipeline_alerting_trigger" {
  name        = "vertex_pipeline_alerting_trigger"
  description = "This job runs daily at 10AM and triggers the vertex ai alerting cloud function "
  schedule    = "0 9 * * *"
  region      = var.gcp_region
  time_zone   = "Europe/Berlin"

  pubsub_target {
    topic_name = google_pubsub_topic.vertex_pipeline_alerting_topic.id
    data       = base64encode("Triggering the vertex alerting cloud function...")
  }

  depends_on = [
    google_pubsub_topic.vertex_pipeline_alerting_topic
  ]
}
