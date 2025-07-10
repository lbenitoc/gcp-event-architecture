# Procesamiento Automático de Archivos - GCP

## ¿Qué hace?
Sistema que procesa archivos automáticamente al subirlos a Google Cloud Storage.

**Flujo:** Subir archivo → Procesamiento automático → Archivo modificado en bucket de salida

## Setup rápido

### 1. Configurar proyecto
```bash
# Cambiar TU_PROJECT_ID por tu proyecto real
export PROJECT_ID=TU_PROJECT_ID

# Habilitar APIs
gcloud services enable cloudfunctions.googleapis.com cloudbuild.googleapis.com pubsub.googleapis.com storage.googleapis.com
```

### 2. Configurar variables
Editar `terraform/environments/dev/terraform.tfvars`:
```hcl
project_id = "TU_PROJECT_ID"
input_bucket_name = "tu-nombre-unico-input"
output_bucket_name = "tu-nombre-unico-output"
```

Editar `terraform/main.tf` línea 8:
```hcl
bucket = "TU_PROJECT_ID-terraform-state"
```

### 3. Deploy
```bash
# Crear bucket para estado
gsutil mb gs://TU_PROJECT_ID-terraform-state

# Deploy
cd terraform
terraform init
terraform apply -var-file="environments/dev/terraform.tfvars"
```

### 4. Probar
```bash
echo "test" > test.txt
gsutil cp test.txt gs://tu-nombre-unico-input/
gsutil ls gs://tu-nombre-unico-output/
```

## Deploy automático
Ver `PIPELINE.md` para configurar GitHub Actions.

## Limpiar
```bash
terraform destroy -var-file="environments/dev/terraform.tfvars"
```