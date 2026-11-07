terraform {
  required_version = "= 1.16.2"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Import the cloud image once; each VM gets its own writable disk.
resource "libvirt_volume" "base_image" {
  name   = "terraformkvm-base.qcow2"
  pool   = var.storage_pool
  source = pathexpand(var.cloud_image_path) # Because ~ in paths
  format = "qcow2"

}

resource "libvirt_volume" "os_disk" {
  for_each = var.vms

  name           = "${each.key}.qcow2"
  pool           = var.storage_pool
  base_volume_id = libvirt_volume.base_image.id
  size           = each.value.disk_gb * 1073741824
  format         = "qcow2"
}

resource "libvirt_domain" "vm" {
  for_each = var.vms

  name   = each.key
  memory = each.value.memory_mb
  vcpu   = each.value.vcpu

  cloudinit = libvirt_cloudinit_disk.vm[each.key].id

  boot_device {
    dev = ["hd"]
  }

  # OS disk cloned from the cloud image.
  disk {
    volume_id = libvirt_volume.os_disk[each.key].id
  }

  network_interface {
    network_name = var.network_name
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
    autoport    = true
  }
}

resource "libvirt_cloudinit_disk" "vm" {
  for_each = var.vms

  name = "${each.key}-cloudinit.iso"
  pool = var.storage_pool

  user_data = "#cloud-config\n${yamlencode({
    groups = ["sudo"]
    users = [{
      name                = "pesant"
      groups              = ["sudo"]
      shell               = "/bin/bash"
      sudo                = "ALL=(ALL) NOPASSWD:ALL"
      lock_passwd         = true
      ssh_authorized_keys = [trimspace(file(pathexpand(var.ssh_public_key_path)))]
    }]
    ssh_pwauth   = false
    disable_root = true
  })}"

  meta_data = yamlencode({
    "instance-id"    = each.key
    "local-hostname" = each.key
  })
}
