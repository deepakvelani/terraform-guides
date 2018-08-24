variable "tfe_token"      { }
variable "tfe_org_name"   { }
variable "tfe_org_email"  { }
variable "producer_name"  { default = "dynamic-aws-creds-producer" }
variable "consumer_name"  { default = "dynamic-aws-creds-consumer" }
variable "aws_access_key" { }
variable "aws_secret_key" { }

provider "tfe" {
  token    = "${var.tfe_token}"
}

resource "tfe_organization" "org" {
  name  = "${var.tfe_org_name}"
  email = "${var.tfe_org_email}"
}

resource "tfe_organization_token" "token" {
  organization = "${tfe_organization.org.id}"
}

resource "tfe_team" "producer" {
  name         = "${var.producer_name}"
  organization = "${tfe_organization.org.id}"
}


resource "tfe_team_token" "producer" {
  team_id = "${tfe_team.producer.id}"
}

resource "tfe_team" "consumer" {
  name         = "${var.consumer_name}"
  organization = "${tfe_organization.org.id}"
}


resource "tfe_team_token" "consumer" {
  team_id = "${tfe_team.consumer.id}"
}

# Create Producer workspace
resource "tfe_workspace" "producer" {
  name         = "${var.producer_name}"
  organization = "${tfe_organization.org.id}"
}

# Producer team has admin priviledges on "Producer" workspace
resource "tfe_team_access" "producer_workspace_producer_admin" {
  access       = "admin"
  team_id      = "${tfe_team.producer.id}"
  workspace_id = "${tfe_workspace.producer.id}"
}

# Consumer can read from "Producer" workspace remote state
resource "tfe_team_access" "producer_workspace_consumer_read" {
  access       = "read"
  team_id      = "${tfe_team.consumer.id}"
  workspace_id = "${tfe_workspace.producer.id}"
}

# Create Consumer workspace
resource "tfe_workspace" "consumer" {
  name         = "${var.consumer_name}"
  organization = "${tfe_organization.org.id}"
}

# Producer team has admin priviledges on "Consumer" workspace
resource "tfe_team_access" "consumer_workspace_producer_admin" {
  access       = "admin"
  team_id      = "${tfe_team.producer.id}"
  workspace_id = "${tfe_workspace.consumer.id}"
}

# Consumer team has admin priviledges on "Consumer" workspace
resource "tfe_team_access" "consumer_workspace_consumer_admin" {
  access       = "admin"
  team_id      = "${tfe_team.consumer.id}"
  workspace_id = "${tfe_workspace.consumer.id}"
}

# Store sensitive "Producer" workspace variables in TFE
resource "tfe_variable" "aws_access_key" {
  key          = "aws_access_key"
  value        = "${var.aws_access_key}"
  category     = "terraform"
  sensitive    = true
  workspace_id = "${tfe_workspace.producer.id}"
}

resource "tfe_variable" "aws_secret_key" {
  key          = "aws_secret_key"
  value        = "${var.aws_secret_key}"
  category     = "terraform"
  sensitive    = true
  workspace_id = "${tfe_workspace.producer.id}"
}

resource "tfe_variable" "confirm_destroy" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = "${tfe_workspace.producer.id}"
}

module "producer_workspace" {
  # source = "github.com/hashicorp/terraform-guides//infrastructure-as-code/dynamic-aws-creds/producer-workspace"
  source = "../../dynamic-aws-creds/producer-workspace"

  name           = "${var.producer_name}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_access_key = "${var.aws_access_key}"
}

# Add remote enhanced backend Terraform config locally
resource "null_resource" "remote_backend" {
  provisioner "local-exec" {
    command = "echo 'terraform { backend \"remote\" {} }' > tfe.tf"
  }
}

# Remote state outputs for consumer
output "zREADME" {
  value = <<README
After your first apply, re-initialize Terraform with your newly created workspace
backend so you can begin using it for remote state. A file named `tfe.tf` has
been placed locally which contains the "remote" backend Terraform provider block.
This new provider block will allow you to run the below init command to initialize
the enhanced remote backend for TFE.

Remove the `tfe.tf` file if you want to switch back to local state.

Note that normally you would _not_ pass the `token` in via the CLI, but
for the sake of simplicity in this example, we are doing that below.

See below best practices for configuring the backend.

https://www.terraform.io/docs/backends/config.html
https://www.terraform.io/docs/backends/types/remote.html#configuration-variables

```
  $ terraform init \
        -backend=true \
        -reconfigure=true \
        -backend-config="organization=${tfe_organization.org.id}" \
        -backend-config="token=${tfe_team_token.producer.token}" \
        -backend-config="workspaces=[{name=\"${tfe_workspace.producer.name}\"}]"
```

You will see the below prompt, enter `yes`.

```
Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "remote" backend. No existing state was found in the newly
  configured "remote" backend. Do you want to copy this state to the new "remote"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes
```

Now head over to the Consumer workspace in a new terminal.

  $ cd ../consumer-workspace

Set the below environment variables in the Consumer workspace.

  ${format("export TF_VAR_tfe_org_name=%s", tfe_organization.org.name)}
  ${format("export TF_VAR_tfe_consumer_workspace=%s", tfe_workspace.consumer.name)}
  ${format("export TF_VAR_tfe_consumer_token=%s", tfe_team_token.consumer.token)}
  ${format("export TF_VAR_tfe_producer_workspace=%s", tfe_workspace.producer.name)}


Initialize the enhanced remote backend.

```
  $ terraform init \
        -backend=true \
        -backend-config="organization=${tfe_organization.org.id}" \
        -backend-config="token=${tfe_team_token.consumer.token}" \
        -backend-config="workspaces=[{name=\"${tfe_workspace.consumer.name}\"}]"
```

Run a plan

  $ terraform plan

Then run the apply through TFE by going to the plan URL output.
README
}

output "backend" {
  value = "${module.producer_workspace.backend}"
}

output "role" {
  value = "${module.producer_workspace.role}"
}
