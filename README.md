# Arquitectura Orientada a Eventos - GCP

## Descripción
Arquitectura que procesa automáticamente archivos al ser subidos a Cloud Storage usando Pub/Sub y Cloud Functions.

## Arquitectura
```
Cloud Storage (Input) → Pub/Sub Topic → Cloud Function → Cloud Storage (Output)
```

## Componentes
- **Input Bucket**: `test-gcp-input-files-dev`
- **Output Bucket**: `test-gcp-processed-files-dev`
- **Pub/Sub Topic**: `file-processing-topic`
- **Cloud Function**: `file-processor-function`

## Despliegue

### Prerequisitos
- Google Cloud CLI instalado
- Terraform instalado
- Proyecto GCP: `test-gcp-465402`

### Comandos
```bash
# Autenticación
gcloud auth application-default login
gcloud config set project test-gcp-465402

# Despliegue
cd terraform
terraform init
terraform apply -var-file="environments/dev/terraform.tfvars"
```

### Prueba
```bash
# Crear archivo de prueba
echo "archivo de prueba" > test.txt

# Subir archivo (esto activa el procesamiento automático)
gsutil cp test.txt gs://test-gcp-input-files-dev/

# Verificar que se procesó
gsutil ls gs://test-gcp-processed-files-dev/

# Ver contenido procesado
gsutil cp gs://test-gcp-processed-files-dev/processed_test.txt ./
type processed_test.txt
```

## Variables Configurables
- `project_id`: ID del proyecto GCP
- `region`: Región de despliegue
- `input_bucket_name`: Nombre del bucket de entrada
- `output_bucket_name`: Nombre del bucket de salida

## Limpieza de Recursos
```bash
# Eliminar todos los recursos creados
cd terraform
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

## Estructura del Proyecto
```
gcp-event-architecture/
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   └── environments/
│       └── dev/
│           └── terraform.tfvars
├── functions/
│   └── file-processor/
│       ├── main.py
│       └── requirements.txt
├── scripts/
│   └── cleanup.sh
└── README.md
```