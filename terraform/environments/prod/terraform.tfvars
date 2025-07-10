project_id = "test-gcp-465402"
region     = "us-central1"
zone       = "us-central1-a"
environment = "prod"

# Nombres de recursos para producción
input_bucket_name    = "test-gcp-input-files-prod"
output_bucket_name   = "test-gcp-processed-files-prod"
pubsub_topic_name    = "file-processing-topic-prod"
function_name        = "file-processor-function-prod"