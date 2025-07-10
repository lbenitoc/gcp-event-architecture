# Pipeline CI/CD - GitHub Actions

## Descripción
Pipeline automatizado que despliega la Cloud Function usando Terraform en múltiples ambientes.

## Flujo del Pipeline

### Pull Request
- **Trigger:** PR hacia master
- **Acción:** `terraform plan`
- **Propósito:** Validar cambios antes del merge

### Push a Master
- **Trigger:** Push directo a master
- **Acción:** `terraform apply`
- **Propósito:** Despliegue automático a desarrollo

## Componentes del Pipeline

### 1. Authentication
- Service Account: `github-actions-sa@test-gcp-465402.iam.gserviceaccount.com`
- Secret: `GCP_SA_KEY` (clave JSON en GitHub Secrets)

### 2. Backend Remoto
- **Bucket:** `test-gcp-terraform-state-465402`
- **Path:** `terraform/state/default.tfstate`

### 3. Ambientes
- **DEV:** Desplegado automáticamente en push a master
- **PROD:** Configurado en `environments/prod/`

## Arquitectura Modular 
```
terraform/
├── main.tf                    # Configuración principal
├── modules/
│   └── cloud-function/        # Módulo reutilizable
└── environments/
├── dev/                   # Variables desarrollo
└── prod/                  # Variables producción
```