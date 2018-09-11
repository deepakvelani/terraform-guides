variable "tfe_token"      { }
variable "tfe_org_name"   { }
variable "tfe_org_email"  { }
variable "producer_name"  { default = "dynamic-aws-creds-producer" }
variable "consumer_name"  { default = "dynamic-aws-creds-consumer" }

variable "vcs_repo_identifier" { default = "hashicorp/terraform-guides" }
variable "vcs_repo_branch"     { default = "f-dynamic-aws-creds-tfe" }
variable "producer_wd"         { default = "infrastructure-as-code/dynamic-aws-creds-tfe/producer-workspace" }
variable "consumer_wd"         { default = "infrastructure-as-code/dynamic-aws-creds-tfe/producer-workspace" }

variable "aws_region"            { default = "us-east-1" }
variable "aws_access_key_id"     { }
variable "aws_secret_access_key" { }
variable "vault_addr"            { }
variable "vault_token"           { }

variable "tags" {
  type    = "map"
  default = {}
}

variable "tags_list" {
  type    = "list"
  default = []
}
