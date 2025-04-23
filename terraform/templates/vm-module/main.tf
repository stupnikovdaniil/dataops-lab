terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

locals {
  vm_config = yamldecode(file(var.vm_config_file))
  vm_secret = yamldecode(file(var.vm_secret_file))
}

resource "proxmox_vm_qemu" "vm" {
  name        = local.vm_config.vm_name
  target_node = local.vm_config.target_node
  clone       = local.vm_config.template_name
  os_type     = "cloud-init"

  cores  = local.vm_config.vm_cores
  memory = local.vm_config.vm_memory

  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"

  disk {
    slot    = "scsi0"
    type    = "disk"
    storage = "local-lvm"
    size    = local.vm_config.vm_disk_size
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ciuser     = local.vm_secret.cloudinit_user
  cipassword = local.vm_secret.cloudinit_password
  sshkeys    = file(local.vm_secret.ssh_public_key_path)
  ipconfig0  = "ip=dhcp"

  agent = 1
}

