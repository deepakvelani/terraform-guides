variable "tfe_org_name"           { }
variable "tfe_producer_workspace" { }
variable "tfe_consumer_workspace" { }
variable "tfe_consumer_token"     { }
variable "aws_region"             { default = "us-east-1" }

variable "tags" {
  type    = "map"
  default = {}
}
