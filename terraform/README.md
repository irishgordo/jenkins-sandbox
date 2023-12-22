### Run Like:
### Basic Gist:
- needs (`terraform --version`) v1.3.5 and greater
- leveraging Harvester Terraform Provider and Cloud Config, we can simultaneously provision (much much much much faster than Ansible) different integration elements that we need to stand up in order to test ex: Docker-based-Rancher, Elasticsearch, MinIO (for S3), Openstack, and more.
- all that's needed as a pre-req, is a `local.yaml` that will exist within the root of the directory that points to a Harvester cluster
- state is separate by design from one application to the next, there is "carry-over" with overhead on re-downloading images (for now...), "modules" is currently deprecated as juggling "shared resources" could get tricky
- additionally then Ansible runs on the created VM in Harvester

#### With Terraform:
- drop your Harvester Cluster, `local.yaml` in the root of the project for quick integrations
- basic flow:
    - build a local.tfvars from the local-sample.tfvars (place inside provisioning application env folder), usually only `SSH_KEY` is required, can fall back on defaults for others
    - then `terraform init` from within the application directory
    - then `terraform apply -var-file="env/local.tfvars"`:
        - pay attention to the "output" message provided at the end of provisioning, that will provide additional insight on an integration application basis (as in providing information about ports used, the credentials, access points, follow-up steps, etc.)
    - then to remove `terraform apply -var-file="env/local.tfvars" -destroy`
- `variables.tf` holds all variables with defaults used, local.tfvars will override when variable is provided

## Single App Currently:
- single app currently is Jenkins that runs in Docker, that runs a replayable Ansible script.
- this is all kicked off on GitHub Actions -> Self Hosted Runner -> Terraform Provisioning Resources on Harvester Cluster (for Jenkins) -> Ansible Running w/ Terraform on Jenkins SBX VM that will ensure new pipeline code is picked up on Pushes or PRs to sandbox branch