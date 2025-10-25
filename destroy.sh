#!/bin/bash
# destroy.sh - Safely destroy all Terraform-managed Alibaba Cloud resources

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail

echo "=== Remove HTTP rule from default node pool ==="

# Navigate to the Terraform directory (update if your .tf files are elsewhere)
cd terraform

echo "Destroying all Terraform-managed resources..."

# Initialize Terraform (in case plugins/providers are missing)
terraform init

# Destroy all resources
terraform destroy -auto-approve

echo "All resources destroyed successfully."
