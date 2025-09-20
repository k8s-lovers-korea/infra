variable "location" {
  type    = string
  default = "koreacentral"
}

variable "resource_group_name" {
  type    = string
  default = "clustergoose-project"
}

variable "prefix" {
  type    = string
  default = "clustergoose"
}

variable "cluster_name" {
  type    = string
  default = "clustergoose-aks-cluster"
}

variable "kubernetes_version" {
  type    = string
  default = "1.32.6"
}

variable "dns_prefix" {
  type    = string
  default = "clustergooseaks"
}

variable "acr_name" {
  type    = string
  default = "acrclustergoose"
}

variable "node_vm_size" {
  type    = string
  default = "Standard_D2ads_v5"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "node_min_count" {
  type    = number
  default = 2
}
variable "node_max_count" {
  type    = number
  default = 5
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key file for node pool access"
  default     = "/root/.ssh/id_rsa.pub"
}

variable "pod_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "clustergoose"
    managed-by  = "terraform"
  }
}
