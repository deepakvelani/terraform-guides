# Retrieve TFE oAuth token: https://github.com/terraform-providers/terraform-provider-tfe/issues/10
data "template_file" "tfe_oauth_token" {
  template = "${file("${path.module}/tfe-oauth-token.sh.tpl")}"

  vars = {
    token        = "${var.tfe_token}"
    organization = "${var.tfe_org_name}"
  }
}

# Get TFE token
resource "null_resource" "tfe_oauth_token" {
  provisioner "local-exec" {
    command = <<EOF
echo ${data.template_file.tfe_oauth_token.rendered} # Runtime install Consul in -dev mode
EOF
  }
}

provider "tfe" {
  token = "${var.tfe_token}"
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

  # VCS settings
  vcs_repo {
    identifier     = "${var.vcs_repo_identifier}"
    branch         = "${var.vcs_repo_branch}"
    oauth_token_id = "${data.template_file.tfe_oauth_token.rendered}"
  }

  working_directory = "${var.producer_wd}"
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

  # VCS settings
  vcs_repo {
    identifier     = "${var.vcs_repo_identifier}"
    branch         = "${var.vcs_repo_branch}"
    oauth_token_id = "${data.template_file.tfe_oauth_token.rendered}"
  }

  working_directory = "${var.consumer_wd}"
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

module "producer_workspace" {
  # source = "github.com/hashicorp/terraform-guides//infrastructure-as-code/dynamic-aws-creds/producer-workspace"
  source = "../../dynamic-aws-creds/producer-workspace"

  name                  = "${var.producer_name}"
  tags                  = "${var.tags}"
  tags_list             = "${var.tags_list}"
  vault_addr            = "${var.vault_addr}"
  vault_token           = "${var.vault_token}"
  aws_region            = "${var.aws_region}"
  aws_access_key_id     = "${var.aws_access_key_id}"
  aws_secret_access_key = "${var.aws_secret_access_key}"
}

# Store "Producer" workspace variables in TFE
resource "tfe_variable" "vault_token" {
  key          = "vault_token"
  value        = "${var.vault_token}"
  category     = "terraform"
  sensitive    = true
  workspace_id = "${tfe_workspace.producer.id}"
}

resource "tfe_variable" "vault_addr" {
  key          = "vault_addr"
  value        = "${module.producer_workspace.vault_addr}"
  category     = "terraform"
  workspace_id = "${tfe_workspace.producer.id}"
}

resource "tfe_variable" "confirm_destroy" {
  key          = "CONFIRM_DESTROY"
  value        = "1"
  category     = "env"
  workspace_id = "${tfe_workspace.producer.id}"
}

# Add remote enhanced backend Terraform config locally
resource "null_resource" "remote_backend" {
  provisioner "local-exec" {
    command = "echo 'terraform { backend \"remote\" {} }' > tfe.tf"
  }
}
