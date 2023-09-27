######################################################################################
# Retail Media Vertex AI Pipeline Trigger
# Cloud function triggers a vertex ai pipeline with the provided configuration from RM
######################################################################################

resource "google_cloudfunctions_function" "vertex-ai-pipeline-trigger" {
  name                  = "retailmedia-vertex-ai-pipeline-trigger"
  description           = "Cloud function that triggers the vertex AI GAM model pipeline"
  runtime               = "python311"
  service_account_email = google_service_account.vertex_ai_sa.email
  region                = var.gcp_region
  available_memory_mb   = var.function_memory
  source_archive_bucket = google_storage_bucket.rm_vertex_pipeline_source_code.name
  source_archive_object = google_storage_bucket_object.rm_vertex_pipeline_source_code_python.name

  environment_variables = {
    service_account_name = google_service_account.vertex_ai_sa.email
    region               = "europe-central2"
  }

  timeout     = 540
  entry_point = "create_vertex_pipeline_run"


  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.rm-vertex-pipeline-trigger-topic.name
  }


  depends_on = [
    google_pubsub_topic.rm-vertex-pipeline-trigger-topic,
    data.archive_file.rm_vertex_pipeline_source_code_python,
    google_storage_bucket_object.rm_vertex_pipeline_source_code_python
  ]
}

data "archive_file" "rm_vertex_pipeline_source_code_python" {
  type        = "zip"
  source_dir  = "${path.module}/files/cloud_functions/vertex_pipeline"
  output_path = "${path.module}/files/vertex_pipeline.zip"
}


resource "google_storage_bucket_object" "rm_vertex_pipeline_source_code_python" {
  name = "rm_vertex_pipeline-${lower(replace(base64encode(data.archive_file.rm_vertex_pipeline_source_code_python.output_md5), "=", ""))}.zip"
  // we append the app hash to the filename as a temporary workaround for https://github.com/terraform-providers/terraform-provider-google/issues/1938
  bucket = google_storage_bucket.rm_vertex_pipeline_source_code.name
  source = data.archive_file.rm_vertex_pipeline_source_code_python.output_path
}


######################################################################################
# Retail Media Vertex AI Alerting Function
######################################################################################

resource "google_cloudfunctions_function" "vertex-ai-pipeline-alerting-function" {
  name                  = "vertex-ai-pipeline-alerting"
  description           = "Function that checks whether there are any vertex ai pipeline jobs executing for longer than 12 hours"
  runtime               = "python311"
  service_account_email = google_service_account.vertex_ai_sa.email
  region                = var.gcp_region
  available_memory_mb   = var.function_memory
  source_archive_bucket = google_storage_bucket.rm_vertex_pipeline_alerting_source_code.name
  source_archive_object = google_storage_bucket_object.rm_vertex_pipeline_alerting_source_code_python.name

  environment_variables = {
    service_account_name = google_service_account.vertex_ai_sa.email
    region               = "europe-central2"
  }

  timeout     = 540
  entry_point = "check_pipeline_jobs"


  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.vertex_pipeline_alerting_topic.name
  }


  depends_on = [
    data.archive_file.rm_vertex_pipeline_source_code_python,
    google_storage_bucket_object.rm_vertex_pipeline_source_code_python
  ]
}

data "archive_file" "rm_vertex_pipeline_alerting_source_code_python" {
  type        = "zip"
  source_dir  = "${path.module}/files/cloud_functions/vertex_pipeline_alerting"
  output_path = "${path.module}/files/vertex_pipeline_alerting.zip"
}




resource "google_storage_bucket_object" "rm_vertex_pipeline_alerting_source_code_python" {
  name = "rm_vertex_pipeline-${lower(replace(base64encode(data.archive_file.rm_vertex_pipeline_alerting_source_code_python.output_md5), "=", ""))}.zip"
  // we append the app hash to the filename as a temporary workaround for https://github.com/terraform-providers/terraform-provider-google/issues/1938
  bucket = google_storage_bucket.rm_vertex_pipeline_alerting_source_code.name
  source = data.archive_file.rm_vertex_pipeline_alerting_source_code_python.output_path
}






