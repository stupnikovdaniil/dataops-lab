output "vms" {
  value = {
    for name, vm in module.vms : name => {
      ip       = vm.vm_ip
      user     = vm.cloud_user
      password = vm.cloud_password
    }
  }
}

