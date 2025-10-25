variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "eu-central-1"
}
variable "node_password" {
  description = "Password for ECS worker nodes"
  default     = "YourSecurePassword123!"
}
