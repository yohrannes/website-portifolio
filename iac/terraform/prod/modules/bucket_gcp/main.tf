resource "google_storage_bucket" "webport" {
  name          = "${var.project_id}-bucket"
  location      = "us-central1"
  storage_class = "REGIONAL"
  force_destroy = true
  project       = var.project_id

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_member" "member" {
  provider = google
  bucket   = google_storage_bucket.webport.name
  role     = "roles/storage.objectViewer"
  member   = "allUsers"
}