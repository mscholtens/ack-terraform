# Alibaba Cloud ACK + Terraform + Helm Nginx Example

This project demonstrates:

- Creating an ACK cluster with Terraform
- Deploying a Helm chart (Nginx Hello World)
- Full DevOps pipeline experience on Alibaba Cloud

## How to Run

1. Set your Alibaba Cloud credentials as environment variables:
```bash
export ALICLOUD_ACCESS_KEY=<your_access_key>
export ALICLOUD_SECRET_KEY=<your_secret_key>
2. Run the deploy script
./deploy.sh
3. Wait for the LoadBalancer to get an external IP, then open in your browser.

---

✅ **This setup shows:**  

- IaC (Terraform for ACK + VPC)  
- Kubernetes orchestration (ACK)  
- Helm chart deployment (Nginx)  
- Automation (shell script to combine everything)  

---
