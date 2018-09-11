provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

# Spin up Vault cluster with sane defaults
module "vault" {
  source = "github.com/hashicorp/vault-guides//operations//provision-vault//dev//terraform-aws"

  name         = "${var.name}"
  network_tags = "${var.tags}"

  consul_version         = "${var.consul_version}"
  consul_url             = "${var.consul_url}"
  consul_config_override = "${var.consul_config_override}"

  vault_servers         = "${var.vault_servers}"
  vault_instance        = "${var.vault_instance}"
  vault_version         = "${var.vault_version}"
  vault_url             = "${var.vault_url}"
  vault_public          = "${var.vault_public}"
  vault_config_override = "${var.vault_config_override}"
  vault_tags            = "${var.tags}"
  vault_tags_list       = "${var.tags_list}"
}

provider "vault" {
  address = "${var.vault_addr}"
  # address = "${format("%s%s:8200", var.vault_protocol, var.vault_addr != "" ? var.vault_addr : module.vault.vault_lb_dns)}"
  token   = "${var.vault_token}"

  ca_cert_file          = "${var.vault_ca_cert_file}"
  ca_cert_dir           = "${var.vault_ca_cert_dir}"
  skip_tls_verify       = "${var.vault_skip_tls_verify}"
  max_lease_ttl_seconds = "${var.vault_max_lease_ttl_seconds}"
}

resource "vault_aws_secret_backend" "consumer" {
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"

  region      = "${var.aws_region}"
  path        = "${var.name}-consumer"
  description = "Generate AWS credentials for Consumer workspace"

  default_lease_ttl_seconds = "${var.default_lease_ttl}"
  max_lease_ttl_seconds     = "${var.max_lease_ttl}"
}

resource "vault_aws_secret_backend_role" "consumer" {
  backend = "${vault_aws_secret_backend.consumer.path}"
  name    = "${var.name}-consumer-role"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*", "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
