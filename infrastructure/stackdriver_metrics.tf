locals {
  vertex_custom_metric_map = [
    {
      "name" : "vertex_pipeline_duration_metric",
      "filter" : "resource.type=cloud_function AND textPayload=~\".*is running already longer than 8 hours and is in the state*.\""
    }
  ]
}

resource "google_logging_metric" "vertex_ai_custom_metrics" {
  count  = length(local.vertex_custom_metric_map)
  name   = local.vertex_custom_metric_map[count.index].name
  filter = local.vertex_custom_metric_map[count.index].filter
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}