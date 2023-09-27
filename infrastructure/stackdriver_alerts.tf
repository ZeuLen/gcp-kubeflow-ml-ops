################################################
# START Model Deployment GAM Pipeline Alerts
################################################

resource "google_monitoring_alert_policy" "model_deployment_pubsub_errors" {
  display_name = "Gam Model Deployment - Pub/Sub Errors"
  combiner     = "OR"
  conditions {
    display_name = "Pub/Sub Errors"
    condition_threshold {
      filter     = "resource.type = \"pubsub_topic\" AND resource.labels.topic_id = \"rm-vertex-pipeline-trigger-topic\" AND metric.type = \"logging.googleapis.com/log_entry_count\" AND metric.labels.severity = \"ERROR\""
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }

  }
  documentation {
    content   = <<-EOT
            Gam Model Deployment Pipeline Error - Pub/Sub
            
            For more information, review the logs
            EOT
    mime_type = "text/markdown"
  }
  notification_channels = var.env != "prod" ? local.nonprod_notifications : local.rewe_ops_product_team_notifications
}

#cf error
resource "google_monitoring_alert_policy" "model_deployment_function_errors" {
  display_name = "GAM Model Deployment - Cloud Function Errors"
  combiner     = "OR"
  conditions {
    display_name = "Cloud Function Errors"
    condition_threshold {
      filter     = "resource.type = \"cloud_function\" AND resource.labels.function_name = \"retailmedia-vertex-ai-pipeline-trigger\" AND metric.type = \"logging.googleapis.com/log_entry_count\" AND metric.labels.severity = \"ERROR\""
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }

  }
  documentation {
    content   = <<-EOT
          Gam Model Deployment Pipeline Error - Cloud Function

          For more information, review the logs
    EOT
    mime_type = "text/markdown"
  }
  notification_channels = var.env != "prod" ? local.nonprod_notifications : local.rewe_ops_product_team_notifications
}

resource "google_monitoring_alert_policy" "model_pipeline_errors" {
  display_name = "GAM Model Deployment - Vertex Pipeline Errors"
  combiner     = "OR"
  conditions {
    display_name = "Vertex Pipeline Job Errors"
    condition_threshold {
      filter     = "resource.type = \"aiplatform.googleapis.com/PipelineJob\" AND metric.type = \"logging.googleapis.com/log_entry_count\" AND metric.labels.severity = \"ERROR\""
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }

  }
  documentation {
    content   = <<-EOT
          Gam Model Deployment Pipeline Error - Cloud Function

          For more information, review the logs
    EOT
    mime_type = "text/markdown"
  }
  notification_channels = var.env != "prod" ? local.nonprod_notifications : local.rewe_ops_product_team_notifications
}

##runtime
##############################################
# END Model Deployment GAM Pipeline Alerts
##############################################


resource "google_monitoring_alert_policy" "pipeline_duration_alert" {
  display_name = "Vertex AI Pipeline Duration Alert"
  combiner     = "OR"
  conditions {
    display_name = "Vertex AI Pipeline Error"
    condition_threshold {
      filter     = "resource.type=\"cloud_function\" AND metric.type=\"logging.googleapis.com/user/vertex_pipeline_duration_metric\""
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }

  }
  documentation {
    content   = <<-EOT
            Vertex Pipeline Duration Error - Pub/Sub

            For more information, review the logs
            EOT
    mime_type = "text/markdown"
  }
  notification_channels = var.env != "prod" ? local.nonprod_notifications : local.rewe_ops_product_team_notifications
  depends_on = [google_logging_metric.vertex_ai_custom_metrics]
}