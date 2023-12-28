# switching to convention over configuration, dropping local.yaml at the root of the project 'should' suffice
# variable "KUBECONFIG_LOCATION" {
#     description = "the full file path location of the kubeconfig"
#     type = string
# }

variable "SSH_KEY" {
  description = "your public ssh key"
  type = string
}

variable "JENKINSSBXVM_VM_PW" {
  description = "vm password for JENKINSSBXVM"
  type = string
  sensitive = false
  default = "ubuntupw"
}

variable "JENKINSSBXVM_DESIRED_CPU" {
  description = "the desired cpu"
  type = number
  default = 16
}

variable "JENKINSSBXVM_DESIRED_MEM" {
  description = "the desired mem"
  type = string
  default = "32Gi"
}

variable "JENKINSSBXVM_VOLUMES" {
  description = "volumes"
  type = string
  default = "/var/www/jenkinssbxvm"
}

variable "JENKINSSBXVM_DISK_SIZE" {
  description = "disk size"
  type = string
  default = "300Gi"
}

variable "JENKINSSBXVM_NAME" {
  description = "JENKINSSBXVM host name"
  type = string
  default = "jenkinssbxvm-box"
}

variable "JENKINSSBXVM_ROOT_USER" {
  description = "JENKINSSBXVM root user, the username"
  type = string
  default = "ubuntu"
}

variable "JENKINSSBXVM_ROOT_PASSWORD" {
  description = "JENKINSSBXVM root user password for console"
  type = string
  default = "ubuntupw"
  sensitive = false
}

variable JENKINSSBXVM_VM_NETWORK_VLAN {
  description = "the vlan id for the network"
  type = number
  default = 12
}

variable JENKINSSBXVM_VM_NETWORK_VM_NET_NAME {
  description = "the name of the network"
  type = string
  default = "eno2vlan12"
}

variable "runnertempknownhosts" {
    description = "the location of the known_hosts file"
    type = string
    default = "purposefully-bad-path"
}