# ---------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "name" { default = "dynamic-aws-creds" }

variable "tags" {
  type    = "map"
  default = {}
}

variable "tags_list" {
  type    = "list"
  default = []
}

# ---------------------------------------------------------------------------------------------------------------------
# Consul Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "consul_version" { default = "1.2.0" }
variable "consul_url"     { default = "" }

variable "consul_config_override" { default = "" }

# ---------------------------------------------------------------------------------------------------------------------
# Vault Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "vault_servers"  { default = 1 }
variable "vault_instance" { default = "t2.nano" }
variable "vault_version"  { default = "0.11.0" }
variable "vault_url"      { default = "" }

variable "vault_public" {
  description = "Assign a public IP, open port 22 for public access, & provision into public subnets to provide easier accessibility without a Bastion host - DO NOT DO THIS IN PROD"
  default     = true
}

variable "vault_config_override" { default = "" }

# ---------------------------------------------------------------------------------------------------------------------
# Vault/AWS Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "vault_protocol" {
  description = "(Optional) Vault protocol to pass in, defaults to Vault \"http\"."
  default     = "http://"
}

variable "vault_addr" {
  description = "(Optional) Vault address to pass in, defaults to Vault provisioned within module."
  default     = ""
}

variable "vault_token" {
  description = "(Required) Vault token to pass in."
}

variable "vault_ca_cert_file" {
  description = "(Optional) Path to a file on local disk that will be used to validate the certificate presented by the Vault server. May be set via the VAULT_CACERT environment variable."
  default     = ""
}

variable "vault_ca_cert_dir" {
  description = "(Optional) Path to a directory on local disk that contains one or more certificate files that will be used to validate the certificate presented by the Vault server. May be set via the VAULT_CAPATH environment variable."
  default     = ""
}

variable "vault_skip_tls_verify" {
  description = "(Optional) Set this to true to disable verification of the Vault server's TLS certificate. This is strongly discouraged except in prototype or development environments, since it exposes the possibility that Terraform can be tricked into writing secrets to a server controlled by an intruder. May be set via the VAULT_SKIP_VERIFY environment variable."
  default     = "false"
}

variable "vault_max_lease_ttl_seconds" {
  description = "(Optional) Used as the duration for the intermediate Vault token Terraform issues itself, which in turn limits the duration of secret leases issued by Vault. Defaults to 20 minutes and may be set via the TERRAFORM_VAULT_MAX_TTL environment variable. See the section above on Using Vault credentials in Terraform configuration for the implications of this setting."
  default     = "86400"
}

variable "aws_region" {
  description = "(Optional) AWS region for Vault's AWS secret engine to generate creds"
  default     = "us-east-1"
}

variable "aws_access_key_id" {
  description = "(Required) AWS keys used for Vault."
}

variable "aws_secret_access_key" {
  description = "(Required) AWS keys used for Vault."
}

variable "default_lease_ttl" {
  description = "Default lease TTL for AWS creds"
  default     = "120" # 2 minutes
}

variable "max_lease_ttl" {
  description = "Max Lease TTL for AWS creds"
  default     = "240" # 4 minutes
}
