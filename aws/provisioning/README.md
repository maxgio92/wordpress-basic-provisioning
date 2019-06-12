## Init
Create the resources needed to provision and manage the infrastructure via Terraform.

```
export AWS_PROFILE={aws_profile_name}
./init.sh
```

## Provisioning
Provision the infrastructure.

```
export AWS_PROFILE={aws_profile_name}
terraform workspace new {env}
terraform apply
```
