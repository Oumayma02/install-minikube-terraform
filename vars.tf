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