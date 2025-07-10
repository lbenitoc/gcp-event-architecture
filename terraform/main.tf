terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  
  backend "gcs" {
    bucket = "test-gcp-terraform-state-465402"
    prefix = "terraform/state"
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

# Módulo de Cloud Function
module "cloud_function" {
  source = "./modules/cloud-function"
  
  project_id = var.project_id
  region     = var.region
  environment = var.environment
  
  input_bucket_name  = var.input_bucket_name
  output_bucket_name = var.output_bucket_name
  pubsub_topic_name  = var.pubsub_topic_name
  function_name      = var.function_name
}