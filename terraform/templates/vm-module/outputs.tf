output "vm_ip" {
  value = proxmox_vm_qemu.vm.default_ipv4_address
}

output "cloud_user" {
  value = local.vm_secret.cloudinit_user
}

output "cloud_password" {
  value = local.vm_secret.cloudinit_password
}

