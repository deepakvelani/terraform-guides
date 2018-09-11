# Dynamic AWS Creds in TFE

## Setup Producer Workspace

1. Create new user account: https://app.terraform.io/account/new
1. Generate token: https://app.terraform.io/app/settings/tokens
1. [Export environment variables](#export-env-vars). You can alternatively enter these when prompted, though you'll have to do it every Terraform command.
  - `TFE_TOKEN` will be copied from the above step
  - AWS keys are generated from AWS: https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/
1. `$ vault server -dev -dev-root-token-id=root` # Start Vault dev server in seperate terminal tab
1. `$ terraform init`
1. `$ terraform plan`
1. `$ terraform apply`
1. `$ unset TF_VAR_vault_addr`
1. Follow the instructions output from Terraform in the previous step

### Export Env Vars

```
export TF_VAR_tfe_org_name=cam_tfe_trial # Desired org name
export TF_VAR_tfe_org_email=jon+cam_tfe_trial@hashicorp.com # Desired org email
export TF_VAR_tfe_token=${TFE_TOKEN} # This command assumes the TFE token generated above is set in your environment as TFE_TOKEN
export TF_VAR_aws_access_key_id=${AWS_ACCESS_KEY_ID} # AWS Access Key ID - This command assumes the AWS Access Key ID is set in your environment as AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_access_key=${AWS_SECRET_ACCESS_KEY} # AWS Secret Access Key - This command assumes the AWS Access Key ID is set in your environment as AWS_SECRET_ACCESS_KEY
export TF_VAR_vault_addr="http://127.0.0.1:8200" # Vault addr - this temporary until our Vault cluster is provisioned
export TF_VAR_vault_token=root # Vault token - this guide defaults to "root"
```
