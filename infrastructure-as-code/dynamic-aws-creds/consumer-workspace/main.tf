data "terraform_remote_state" "producer" {
  backend = "local"

  config {
    path = "${var.path}"
  }
}

data "vault_aws_access_credentials" "creds" {
  backend = "${var.backend != "" ? var.backend : data.terraform_remote_state.producer.backend}"
  role    = "${var.role != "" ? var.role : data.terraform_remote_state.producer.role}"
}

provider "aws" {
  region     = "${var.region}"
  access_key = "${data.vault_aws_access_credentials.creds.access_key}"
  secret_key = "${data.vault_aws_access_credentials.creds.secret_key}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create AWS EC2 Instance
resource "aws_instance" "consumer" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.nano"
  tags          = "${merge(var.tags, map("Name", format("%s-guide", var.name)))}"
}
