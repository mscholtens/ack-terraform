#!/bin/bash
set -e

echo "=== Step 1: Apply Terraform ==="
cd terraform
terraform init
terraform apply -auto-approve

# Get the cluster ID from Terraform output
CLUSTER_ID=$(terraform output -raw ack_cluster_id)
REGION="eu-central-1"
KUBECONFIG_FILE=../kubeconfig.yaml

echo "=== Step 2: Fetch kubeconfig via Alibaba Cloud CLI ==="

# Use RESTful command without --output
KUBECONFIG_JSON=$(aliyun cs DescribeClusterUserKubeconfig --ClusterId $CLUSTER_ID --region $REGION)

# Extract the 'config' field using jq
KUBECONFIG_CONTENT=$(echo "$KUBECONFIG_JSON" | jq -r '.config')

# Verify the content
if [ -z "$KUBECONFIG_CONTENT" ] || [ "$KUBECONFIG_CONTENT" == "null" ]; then
  echo "ERROR: Failed to fetch kubeconfig"
  exit 1
fi

# Save kubeconfig to file and export
KUBECONFIG_FILE=$(realpath ../kubeconfig.yaml)
echo "$KUBECONFIG_CONTENT" > "$KUBECONFIG_FILE"
export KUBECONFIG="$KUBECONFIG_FILE"
echo "KUBECONFIG=$KUBECONFIG"
echo "Kubeconfig saved to $KUBECONFIG_FILE"

# Sanity check
kubectl cluster-info
echo "Waiting for worker nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=1m
kubectl get nodes
helm ls

echo "=== Step 3: Deploy Helm chart ==="
cd ../helm/nginx
helm upgrade --install nginx . --values values.yaml --kubeconfig "$KUBECONFIG_FILE"

echo "=== Step 4: Wait for LoadBalancer EXTERNAL-IP ==="
SERVICE_NAME="nginx"
NAMESPACE="default"
EXTERNAL_IP=""
echo "Waiting for EXTERNAL-IP..."
while [ -z "$EXTERNAL_IP" ] || [ "$EXTERNAL_IP" = "<pending>" ]; do
  sleep 10
  EXTERNAL_IP=$(kubectl get svc $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
done

echo "=== Step 5: Service Info ==="
kubectl get svc $SERVICE_NAME -n $NAMESPACE
# kubectl describe svc nginx
# kubectl get pods -l app.kubernetes.io/name=nginx
# kubectl describe pods -l app.kubernetes.io/name=nginx
# helm get values nginx
# kubectl get svc nginx -o yaml
# kubectl get deployments
# kubectl describe deployment nginx

echo "=== Step 6: Test via curl ==="
echo "Access Nginx at: http://$EXTERNAL_IP"
curl -s http://$EXTERNAL_IP | head -n 20
