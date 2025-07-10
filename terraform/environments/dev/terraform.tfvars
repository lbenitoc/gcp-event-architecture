 
project_id = "test-gcp-465402"
region     = "us-central1"
zone       = "us-central1-a"
environment = "dev"

# Nombres de recursos
input_bucket_name    = "test-gcp-input-files-dev"
output_bucket_name   = "test-gcp-processed-files-dev"
pubsub_topic_name    = "file-processing-topic"
function_name        = "file-processor-function"