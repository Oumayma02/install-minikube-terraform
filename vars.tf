variable "proxmox_username" {
  description = "Proxmox username"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "https://192.168.254.153:8006/api2/json"
}

variable "pm_api_token_id" {
  description = "Proxmox API Token ID"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API Token Secret"
  type        = string
  sensitive   = true
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "vm_memory" {
  description = "Amount of memory in MB"
  type        = number
}

variable "disk_size" {
  description = "Size of the disk in GB"
  type        = string
}

variable "ssh_key" {
  description = "Path to SSH private key for accessing the VM"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "ssh_user" {
  description = "SSH user for accessing the VM"
  type        = string
  default     = "debian"
}

variable "proxmox_host" {
  description = "Proxmox host"
  type        = string
  default     = "pve"
}

variable "template_name" {
  description = "Template name"
  type        = string
  default     = "minikube"
}
