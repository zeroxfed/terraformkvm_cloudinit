# Cloud-init image
cloud_image_path    = "~/Downloads/Fedora-Cloud-Base-Generic-45-1.4.x86_64.qcow2"
ssh_public_key_path = "~/.ssh/id_ed25519.pub"
storage_pool        = "default"
network_name        = "default"

vms = {
  lab01 = {
    memory_mb = 4096
    vcpu      = 2
    disk_gb   = 30
    mac_id    = 1
  }

  lab02 = {
    memory_mb = 4096
    vcpu      = 2
    disk_gb   = 30
    mac_id    = 2
  }
}

