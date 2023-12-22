terraform {
  required_providers {
    harvester = {
      source = "harvester/harvester"
      #version = "0.6.0"
      version = "0.6.3"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.16.0"
    }
    # unifi = {
    #   source = "paultyng/unifi"
    #   version = "0.41.0"
    # }
    ansible = {
      version = "1.1.0"
      source  = "ansible/ansible"
    }
  }
}


# resource "ansible_vault" "secrets" {
#   vault_file          = "vault.yml"
#   vault_password_file = "/path/to/file"
# }


# provider "unifi" {
#   username = var.UNIFI_USERNAME # optionally use UNIFI_USERNAME env var
#   password = var.UNIFI_PASSWORD # optionally use UNIFI_PASSWORD env var
#   api_url  = var.UNIFI_API_URL  # optionally use UNIFI_API env var
#   allow_insecure = true
# }

locals {
  module_path        = abspath(path.module)
  terraform_script_root_path = abspath("${path.module}/../..")
  codebase_root_path = abspath("${path.module}/../../..")

  # Trim local.codebase_root_path and one additional slash from local.module_path
  module_rel_path    = substr(local.module_path, length(local.terraform_script_root_path)+1, length(local.module_path))
}

provider "harvester" {
  # Configuration options
  kubeconfig = abspath("${local.codebase_root_path}/local.yaml")
}

provider "kubernetes" {
  config_path = abspath("${local.codebase_root_path}/local.yaml")
}