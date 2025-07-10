output "input_bucket_name" {
  description = "Nombre del bucket de entrada"
  value       = google_storage_bucket.input_bucket.name
}

output "output_bucket_name" {
  description = "Nombre del bucket de salida"
  value       = google_storage_bucket.output_bucket.name
}

output "pubsub_topic_name" {
  description = "Nombre del topic de Pub/Sub"
  value       = google_pubsub_topic.file_processing_topic.name
}

output "function_name" {
  description = "Nombre de la Cloud Function"
  value       = google_cloudfunctions_function.file_processor.name
} 
