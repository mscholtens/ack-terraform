terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.261.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# Get available zones
data "alicloud_zones" "default" {}

# Create VPC
resource "alicloud_vpc" "main" {
  vpc_name   = "ack-vpc"
  cidr_block = "192.168.0.0/16"
}

# Create VSwitch
resource "alicloud_vswitch" "main" {
  vswitch_name = "ack-vswitch"
  vpc_id       = alicloud_vpc.main.id
  cidr_block   = "192.168.1.0/24"
  zone_id      = data.alicloud_zones.default.zones[0].id
}

# Create a Security Group for cluster nodes
resource "alicloud_security_group" "ack_sg" {
  vpc_id              = alicloud_vpc.main.id
  security_group_name = "ack-sg"
  description         = "Security group for ACK cluster"
}

# Create Managed Kubernetes Cluster
resource "alicloud_cs_managed_kubernetes" "ack" {
  name          = "ack-demo"
  version       = "1.34.1-aliyun.1"
  cluster_spec  = "ack.standard"
  vswitch_ids   = [alicloud_vswitch.main.id]
  pod_cidr      = "10.100.0.0/16"
  service_cidr  = "172.16.0.0/16"
  new_nat_gateway = true
  security_group_id = alicloud_security_group.ack_sg.id
}

# Node Pool
resource "alicloud_cs_kubernetes_node_pool" "default" {
  node_pool_name      = "default-nodepool"
  cluster_id          = alicloud_cs_managed_kubernetes.ack.id
  vswitch_ids         = [alicloud_vswitch.main.id]
  instance_types      = ["ecs.n4.small"]
  system_disk_category = "cloud_ssd"
  system_disk_size    = 40
  desired_size        = 2
  key_name            = null

  labels {
    key   = "role"
    value = "worker"
  }
}

# HTTP ingress rule for Nginx
resource "alicloud_security_group_rule" "http_ingress" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "80/80"
  security_group_id = alicloud_security_group.ack_sg.id
  cidr_ip           = "0.0.0.0/0"
  nic_type          = "intranet"
  policy            = "accept"
}
