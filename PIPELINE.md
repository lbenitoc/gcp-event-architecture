# Deploy Automático con GitHub Actions

## Setup CI/CD (una sola vez)

### 1. Service Account
```bash
export PROJECT_ID=TU_PROJECT_ID

gcloud iam service-accounts create github-actions-sa --project=$PROJECT_ID
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor"
```

### 2. Clave para GitHub
```bash
gcloud iam service-accounts keys create key.json \
  --iam-account=github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com
```

### 3. Configurar GitHub
1. Tu repo → Settings → Secrets → Actions
2. Nuevo secret: `GCP_SA_KEY`
3. Pegar contenido completo de `key.json`
4. Eliminar archivo: `rm key.json`

### 4. Backend remoto
```bash
gsutil mb gs://$PROJECT_ID-terraform-state
```

Editar `terraform/main.tf` línea 8:
```hcl
bucket = "TU_PROJECT_ID-terraform-state"
```

## Uso
- **Push** → Deploy automático
- **Pull Request** → Solo validación

Ver deploys: Tu repo → Actions tab