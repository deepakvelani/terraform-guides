variable "tfe_org_name"           { }
variable "tfe_producer_workspace" { }
variable "tfe_consumer_workspace" { }
variable "tfe_consumer_token"     { }
variable "ttl"                    { default = "1" }

# Getting the below error in TFE when running remote plans, commenting this out for now
# "Setup failed: Failed to copy slug dir: lstat /Users: no such file or directory"
terraform {
  backend "remote" {
  }
}

# This errors right now due to a bug in the TFE provider: https://github.com/terraform-providers/terraform-provider-tfe/issues/8
data "terraform_remote_state" "producer" {
  backend = "remote"

  config {
    organization = "${var.tfe_org_name}"
    token        = "${var.tfe_consumer_token}"

    workspaces {
      name = "${var.tfe_producer_workspace}"
    }
  }
}

module "consumer_workspace" {
  # source = "github.com/hashicorp/terraform-guides//infrastructure-as-code/dynamic-aws-creds/consumer-workspace"
  source = "../../dynamic-aws-creds/consumer-workspace"

  backend = "${data.terraform_remote_state.producer.backend}"
  role    = "${data.terraform_remote_state.producer.role}"
  name    = "${var.tfe_consumer_workspace}"
  ttl     = "${var.ttl}"
}
