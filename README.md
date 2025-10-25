# Alibaba Cloud ACK + Terraform + Helm Nginx Example

This project demonstrates:

- Creating an ACK cluster with Terraform
- Deploying a Helm chart (Nginx Hello World)
- Full DevOps pipeline experience on Alibaba Cloud

## How to Run

1. Make the scripts executable:

```bash
chmod +x deploy.sh destroy.sh
```

2. Run the deploy script

```bash
./deploy.sh
```

3. Wait for the LoadBalancer to get an external IP, then open it in your browser.
4. To destroy all resources when done:

```bash
./destroy.sh
```

## Reference article
For detailed instructions, architecture explanation, and walkthrough, see:

Launch a Kubernetes cluster in Alibaba Cloud with ACK and Terraform
https://medium.com/@marijnscholtens/launch-a-kubernetes-cluster-in-alibaba-cloud-with-ack-and-terraform-6230e66e0e50

✅ **This setup shows:**  

- IaC (Terraform for ACK + VPC)  
- Kubernetes orchestration (ACK)  
- Helm chart deployment (Nginx)  
- Automation (shell scripts to combine everything)  
