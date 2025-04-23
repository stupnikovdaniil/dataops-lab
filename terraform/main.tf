terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = true
}

locals {
  vm_configs = fileset("${path.module}/vms", "*.json")
}

module "vms" {
  for_each = { for file in local.vm_configs : trimsuffix(file, ".json") => file }

  source = "./templates/vm-module"

  vm_config_file = "vms/${each.value}"
  vm_secret_file = "secrets/${each.value}"
}

