### VertexAI ###

resource "google_service_account" "vertex_ai_sa" {
  account_id   = "retailmedia-vertex-ai-sa"
  display_name = "Vertex AI Service Account"
  description  = "Service account for Vertex AI"
}

resource "google_project_iam_member" "member-role" {
  for_each = toset([
    "roles/storage.objectUser",
    "roles/iam.serviceAccountUser",
    "roles/aiplatform.user",
    "roles/iam.serviceAccountTokenCreator",
    "roles/bigquery.jobUser",
    "roles/aiplatform.customCodeServiceAgent"
    # expand service account for BQ User
  ])
  role = each.key
  member = "serviceAccount:${google_service_account.vertex_ai_sa.email}"
  project = var.project
}

resource "google_project_iam_member" "prod-member-role" {
  for_each = toset([
    "roles/bigquery.user",
    "roles/bigquery.dataViewer",
  ])
  role = each.key
  member = "serviceAccount:${google_service_account.vertex_ai_sa.email}"
  project = local.prod_project_id
}


# Generate JSON key for the vertex ai service account
resource "google_service_account_key" "vertex_ai_sa_key" {
  service_account_id = google_service_account.vertex_ai_sa.id
  public_key_type    = "TYPE_X509_PEM_FILE"
}

