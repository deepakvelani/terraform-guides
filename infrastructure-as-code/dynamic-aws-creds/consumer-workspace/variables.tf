variable "path"    { default = "../producer-workspace/terraform.tfstate" }
variable "backend" { default = "" }
variable "role"    { default = "" }
variable "name"    { default = "dynamic-aws-creds-consumer" }
variable "region"  { default = "us-east-1" }

variable "tags" {
  type    = "map"
  default = {}
}
