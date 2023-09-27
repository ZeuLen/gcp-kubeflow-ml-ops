##########################################################################################################
# Contains the source code of the cloud function responsible for the deployment of the vertex ai pipelines
##########################################################################################################
resource "google_storage_bucket" "rm_vertex_pipeline_artefacts" {
  name          = "${var.env}-vertex-model-pipeline-artefacts"
  project       = local.project_id
  location      = var.gcp_region
  force_destroy = local.is_developer_branch ? true : false

  versioning {
    enabled = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age        = 30
      with_state = "ARCHIVED"
    }
  }
}


resource "google_storage_bucket" "rm_vertex_pipeline_source_code" {
  name          = "${var.env}-vertex_pipeline_source_code"
  project       = local.project_id
  location      = var.gcp_region
  force_destroy = local.is_developer_branch ? true : false

  versioning {
    enabled = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age        = 30
      with_state = "ARCHIVED"
    }
  }
}


resource "google_storage_bucket" "rm_vertex_pipeline_alerting_source_code" {
  name          = "${var.env}-vertex_pipeline_alerting_source_code"
  project       = local.project_id
  location      = var.gcp_region
  force_destroy = local.is_developer_branch ? true : false

  versioning {
    enabled = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age        = 30
      with_state = "ARCHIVED"
    }
  }
}

resource "google_storage_bucket" "retail_media_static_content" {
  name          = "${var.env}-retail_media_static_content"
  project       = local.project_id
  location      = var.gcp_region
  force_destroy = local.is_developer_branch ? true : false

  versioning {
    enabled = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age        = 30
      with_state = "ARCHIVED"
    }
  }
}


###########################
# Retail Media Static Files
###########################

resource "google_storage_bucket" "rm_static_files" {
  name          = "${var.env}-retail-media-static-files"
  project       = local.project_id
  location      = var.gcp_region
  force_destroy = local.is_developer_branch ? true : false

  versioning {
    enabled = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age        = 30
      with_state = "ARCHIVED"
    }
  }
}

resource "google_storage_bucket_object" "rm_upload_static_files" {
  for_each = fileset("CustomerCloud-Modeling-Inf-GAM/RetailMedia-Modelling-GAM/static/", "*")
  name     = each.value
  bucket   = google_storage_bucket.rm_static_files.name
  source   = "CustomerCloud-Modeling-Inf-GAM/RetailMedia-Modelling-GAM/static/${each.value}"

  provisioner "local-exec" {
    command = "echo Uploading ${each.value}"
  }
}