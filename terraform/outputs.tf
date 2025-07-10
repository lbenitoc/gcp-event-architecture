output "input_bucket_name" {
  description = "Nombre del bucket de entrada"
  value       = module.cloud_function.input_bucket_name
}

output "output_bucket_name" {
  description = "Nombre del bucket de salida"
  value       = module.cloud_function.output_bucket_name
}

output "pubsub_topic_name" {
  description = "Nombre del topic de Pub/Sub"
  value       = module.cloud_function.pubsub_topic_name
}

output "function_name" {
  description = "Nombre de la Cloud Function"
  value       = module.cloud_function.function_name
}

output "environment" {
  description = "Environment deployed"
  value       = var.environment
}