output "information_next_steps" {
  value = <<-EOF
    ########################################
    Hello There!!!!
    ########################################
    Deployment of the Jenkins Sandbox VM is complete!
    We now have:
      - A VM with the name of: ${var.JENKINSSBXVM_NAME} that is running a Sandbox Jenkins in Docker With The Jobs Desired of *.groovy loaded
      - Any additional added or versions plugins have been loaded as well
      - The VM has been configured with the following:
        - ${var.JENKINSSBXVM_DESIRED_CPU} CPU
        - ${var.JENKINSSBXVM_DESIRED_MEM} Memory
        - ${var.JENKINSSBXVM_DISK_SIZE} Disk Size
        - ${var.JENKINSSBXVM_VM_NETWORK_VM_NET_NAME} Network Name
        - ${var.JENKINSSBXVM_VM_NETWORK_VLAN} Network VLAN
        - ${var.JENKINSSBXVM_ROOT_USER} Root User
        - ${var.JENKINSSBXVM_ROOT_PASSWORD} Root Password
      - Additionally if anything extra was added to the Harvester Terraform that has now been provisioned as well
      - Alongide all Ansible Playbooks that were desired, have been replayed / re-run so if infrastructure was already present, additional Ansible workflows have been applied
    It is up at: ${harvester_virtualmachine.jenkinssbxvm-vm.network_interface[0].ip_address}
    With the respective ports open of: 80 & 443
    Also!
    The VM's SSH User is: ubuntu
    With the password of: ${var.JENKINSSBXVM_VM_PW}
    You'll still want to get the bootstrapd password for Rancher Latest via something like:
    ```
    ssh-keygen -f ~/.ssh/known_hosts -R "${harvester_virtualmachine.jenkinssbxvm-vm.network_interface[0].ip_address}"
    ssh -oStrictHostKeyChecking=no ubuntu@${harvester_virtualmachine.jenkinssbxvm-vm.network_interface[0].ip_address}
    ```
  EOF

}