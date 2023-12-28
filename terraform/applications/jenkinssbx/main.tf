resource "harvester_network" "mgmt-vlan1-jenkinssbxvm" {
  name      = "jenkinssbxvm"
  namespace = "default"

  vlan_id = var.JENKINSSBXVM_VM_NETWORK_VLAN

  route_mode           = "auto"
  route_dhcp_server_ip = ""

  cluster_network_name = var.JENKINSSBXVM_VM_NETWORK_VM_NET_NAME
}

resource "harvester_image" "ubuntu2204-jammy-jenkinssbxvm" {
  name               = "ubuntu-focal-jenkinssbxvm"
  namespace          = "default"
  storage_class_name = "harvester-longhorn"
  display_name       = "ubuntu-focal-jenkinssbxvm.img"
  source_type        = "download"
  url                = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
}

resource "harvester_ssh_key" "jenkinssbxvm-ssh-key" {
  name      = "jenkinssbxvm-ssh-key"
  namespace = "default"

  public_key = var.SSH_KEY
}

resource "harvester_cloudinit_secret" "cloud-config-jenkinssbxvm" {
    name = "cloud-config-jenkinssbxvm"
    namespace = "default"
    depends_on = [
        harvester_ssh_key.jenkinssbxvm-ssh-key
    ]
    user_data = <<-EOF
      #cloud-config
      password: ${var.JENKINSSBXVM_VM_PW}
      chpasswd:
        expire: false
      ssh_pwauth: true
      package_update: true
      packages:
        - qemu-guest-agent
        - apt-transport-https
        - neovim
        - wget
        - ca-certificates
        - python3
        - python3-pip
        - jq
        - curl
        - gnupg-agent
        - gnupg
        - lsb-release
        - software-properties-common
        - coreutils
        - sshpass
        - tmux
      runcmd:
        - - systemctl
          - enable
          - --now
          - qemu-guest-agent.service
        - curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
        - sh /tmp/get-docker.sh
        - usermod -aG docker ubuntu
        - systemctl enable docker.service
        - systemctl enable containerd.service
        - [pip3, install, ansible]
        - [pip3, install, ansible-core]
        - [ansible-galaxy, collection, install, community.general]
        - [ansible-galaxy, collection, install, community.docker]
        - [ansible-galaxy, collection, install, community.kubernetes]
        - [ansible-galaxy, collection, install, ansible.posix]
      ssh_authorized_keys:
        - ${var.SSH_KEY}
    EOF

}

resource "ansible_playbook" "jenkinssbxvm-vm-ansible-playbook" {
  depends_on = [
    harvester_virtualmachine.jenkinssbxvm-vm
  ]
  ansible_playbook_binary = "ansible-playbook" # this parameter is optional, default is "ansible-playbook"
  playbook                = "ansible/jenkinssbx-vm.yml"

  # Inventory configuration
  name   = "${var.JENKINSSBXVM_NAME} ansible_host=${harvester_virtualmachine.jenkinssbxvm-vm.network_interface[0].ip_address} ansible_sudo_pass=${var.JENKINSSBXVM_VM_PW} ansible_ssh_user=ubuntu ansible_ssh_password=${var.JENKINSSBXVM_VM_PW} ansible_ssh_common_args='-o StrictHostKeyChecking=no'"  # name of the host to use for inventory configuration

  check_mode = false
  diff_mode  = false
  var_files = [
    "ansible/jenkinssbx-vm-vars.yml"
  ]
  # allows for us to be able to see what failed... ?
  ignore_playbook_failure = true

  # Connection configuration and other vars
  extra_vars = {
    ip = harvester_virtualmachine.jenkinssbxvm-vm.network_interface[0].ip_address
  }

  replayable = true
  verbosity  = 6 # set the verbosity level of the debug output for this playbook
}

resource "harvester_virtualmachine" "jenkinssbxvm-vm" {
  depends_on = [
    harvester_cloudinit_secret.cloud-config-jenkinssbxvm
  ]
  name                 = var.JENKINSSBXVM_NAME
  namespace            = "default"
  restart_after_update = true

  description = "Integration VM for Integrations of Harvester"
  tags = {
    ssh-user = "ubuntu"
  }

  cpu    = var.JENKINSSBXVM_DESIRED_CPU
  memory = var.JENKINSSBXVM_DESIRED_MEM

  efi         = true
  secure_boot = false

  run_strategy = "RerunOnFailure"
  hostname     = var.JENKINSSBXVM_NAME
  machine_type = "q35"

  ssh_keys = [
    harvester_ssh_key.jenkinssbxvm-ssh-key.id
  ]

  network_interface {
    name           = "nic-1"
    wait_for_lease = true
    model          = "virtio"
    type           = "bridge"
    network_name   = harvester_network.mgmt-vlan1-jenkinssbxvm.id
    mac_address = "02:00:00:F6:5C:01"
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = var.JENKINSSBXVM_DISK_SIZE
    bus        = "virtio"
    boot_order = 1

    image       = harvester_image.ubuntu2204-jammy-jenkinssbxvm.id
    auto_delete = true
  }


  # https://deploy.equinix.com/developers/guides/jenkinssbxvm/
  cloudinit {
    user_data_secret_name = harvester_cloudinit_secret.cloud-config-jenkinssbxvm.name
    network_data          = ""
  }
}
