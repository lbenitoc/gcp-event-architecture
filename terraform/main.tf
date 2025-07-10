terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Variables
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "zone" {
  description = "GCP Zone"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "input_bucket_name" {
  description = "Input bucket name"
  type        = string
}

variable "output_bucket_name" {
  description = "Output bucket name"
  type        = string
}

variable "pubsub_topic_name" {
  description = "Pub/Sub topic name"
  type        = string
}

variable "function_name" {
  description = "Cloud Function name"
  type        = string
}

# Bucket de entrada
resource "google_storage_bucket" "input_bucket" {
  name          = var.input_bucket_name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

# Bucket de salida
resource "google_storage_bucket" "output_bucket" {
  name          = var.output_bucket_name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

# Pub/Sub Topic
resource "google_pubsub_topic" "file_processing_topic" {
  name = var.pubsub_topic_name
}

# Notificación del bucket al Pub/Sub
resource "google_storage_notification" "bucket_notification" {
  bucket         = google_storage_bucket.input_bucket.name
  topic          = google_pubsub_topic.file_processing_topic.id
  payload_format = "JSON_API_V1"
  event_types    = ["OBJECT_FINALIZE"]
  depends_on     = [google_pubsub_topic_iam_binding.binding]
}

# Permisos para que Storage publique en Pub/Sub
resource "google_pubsub_topic_iam_binding" "binding" {
  topic   = google_pubsub_topic.file_processing_topic.name
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"]
  
  depends_on = [
    google_storage_bucket.input_bucket,
    google_pubsub_topic.file_processing_topic
  ]
}

# Data source para obtener el número del proyecto
data "google_project" "project" {}

# Bucket para el código de la función
resource "google_storage_bucket" "function_source" {
  name          = "${var.project_id}-function-source"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

# Comprimir el código de la función
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../functions/file-processor"
  output_path = "${path.module}/function-source.zip"
}

# Subir el código al bucket
resource "google_storage_bucket_object" "function_source" {
  name   = "function-source-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.function_zip.output_path
}

# Cloud Function
resource "google_cloudfunctions_function" "file_processor" {
  name        = var.function_name
  description = "Procesa archivos cuando llegan al bucket"
  runtime     = "python39"
  region      = var.region

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.function_source.name
  source_archive_object = google_storage_bucket_object.function_source.name
  
  entry_point = "process_file"

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.file_processing_topic.name
  }

  environment_variables = {
    OUTPUT_BUCKET = google_storage_bucket.output_bucket.name
  }
}