
# Local lab provisioning with Terraform and KVM

This project aims to automate the provisioning of KVM virtual machines using Terraform. This helps deploy test machines quickly and easily so that more time can be spent on testing rather than lab management.

Other considerations include:
- The ability to use any off the shelf hardware that can run Linux and supports virtualization.
- Avoidance on cloud services to reduce residual costs, and keep testing more private.
- Complete control over your hardware. Literally hands on.
- No internet connectivity is necessary once all initial software is acquired.
- SSH keys must be installed during imaging to make access quick and easy.

# Installation

**Note:** This configuration assumes Fedora Cloud Base which can be found here: https://fedoraproject.org/cloud/download/

The default configuration will install two guest virtual machines named `lab01` and `lab02`. Each machine will consume 4096 MB of ram, use 2 vCPUs, and require 30 GB of disk space. Make sure you have this available before proceeding.

Clone this repository:
```bash
git clone https://github.com/zeroxfed/terraformkvm_cloudinit
cd terraformkvm_cloudinit
```

Download Fedora Cloud Base:
```bash
wget https://download.fedoraproject.org/pub/fedora/linux/releases/45/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-45-1.4.x86_64.qcow2 -o /home/user/Downloads/
```
 
Find the file:
```bash
ls -lah /home/user/Downloads/*.qcow2
```

Open Terraform settings: (vim, because we're not savages)
```bash
vim /home/user/terraformkvm_cloudinit/terraform.tfvars
```

Replace "CLOUD-BASE-FILE" with the actual downloaded filename:
```
cloud_image_path = "/home/user/Downloads/CLOUD-BASE-FILE.qcow2"
```
   
Review and create the VMs:
```bash
terraform init
terraform plan
terraform apply
```

Find each VM IP address:
```bash
virsh -c qemu:///system net-dhcp-leases default
```

Connect: (profit)
```bash
ssh -i ~/.ssh/id_ed25519 automation@lab01_ip
ssh -i ~/.ssh/id_ed25519 automation@lab02_ip
```

