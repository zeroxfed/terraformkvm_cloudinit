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
    mac_id    = number
  }))

  validation {
    condition = alltrue([
      for vm in values(var.vms) :
      vm.mac_id >= 0 &&
      vm.mac_id <= 16777215 &&
      vm.mac_id == floor(vm.mac_id)
    ])
    error_message = "Each mac_id must be an integer from 0 to 16777215."
  }

  validation {
    condition = length(distinct([
      for vm in values(var.vms) : vm.mac_id
    ])) == length(var.vms)
    error_message = "Each VM must have a unique mac_id."
  }
}

variable "ssh_public_key_path" {
  description = "SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
