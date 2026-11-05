variable "cloud_image_path" {
  description = "Path to cloud-init image"
  type        = string
}

variable "storage_pool" {
  type    = string
  default = "default"
}

variable "network_name" {
  type    = string
  default = "default"
}

variable "vms" {
  type = map(object({
    memory_mb = number
    vcpu      = number
    disk_gb   = number
  }))
}

variable "ssh_public_key_path" {
  description = "SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
