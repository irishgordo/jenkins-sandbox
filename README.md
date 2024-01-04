# Needed For Quickly Iterating Figuring Out Pipelines

## Notes

- deploy Jenkins with Terraform & Ansible automatically on Harvester
- could be leveraged for CI or just plan updating Jenkins programmatically


## Setup Thing:
```

ubuntu@self-hosted-runner:~$ sudo vim /etc/ssh/ssh_config
ubuntu@self-hosted-runner:~$ sudo systemctl restart ssh
ssh.service   ssh.socket    sshd.service
ubuntu@self-hosted-runner:~$ sudo systemctl restart ssh.service
ubuntu@self-hosted-runner:~$ sudo systemctl restart ssh.socket
ubuntu@self-hosted-runner:~$ sudo systemctl restart sshd.service
ubuntu@self-hosted-runner:~$ exit

```

Had to change UserKnownHostsFile /dev/null ... -o option in nested terraform in conjunction with a few other things wasn't working...
to improve...
Probably due to some configuration issue...
Will revisit...
As self-hosted runner would need that modification to `sudo vim /etc/ssh/ssh_config`