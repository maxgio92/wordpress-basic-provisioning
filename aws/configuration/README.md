## Configure
Build the AWS AMI configured to run basic Wordpress installation.
For more information on the stack please see ../../docker/.

```
export AWS_PROFILE={aws_profile_name} \
    APP_NAME={app_name} \
    ENVIRONMENT={environment} \
    DB_PASSWORD={db_password} \
    DB_ROOT_PASSWORD={db_root_password} \
    FTP_PASSWORD={ftp_password}
packer build build.json
```
