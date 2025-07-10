 #!/bin/bash
# Script para limpiar recursos

echo "Eliminando recursos de Terraform..."
cd terraform
terraform destroy -var-file="environments/dev/terraform.tfvars" -auto-approve

echo "Recursos eliminados exitosamente"