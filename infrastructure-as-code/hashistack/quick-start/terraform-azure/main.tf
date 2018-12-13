resource "azurerm_resource_group" "hashistack" {
  name     = "${var.name}"
  location = "${var.azure_region}"
}

module "ssh_key" {
  source               = "github.com/hashicorp-modules/ssh-keypair-data.git"
  private_key_filename = "id_rsa_${var.name}"
}

module "network_azure" {
  source           = "git@github.com:hashicorp-modules/network-azure.git"
  name             = "${var.name}"
  environment      = "${var.environment}"
  location         = "${var.azure_region}"
  os               = "${var.azure_os}"
  admin_username   = "${var.admin_username}"
  admin_password   = "${var.admin_password}"
  public_key_data  = "${module.ssh_key.public_key_openssh}"
  bastion_vm_size = "${var.azure_vm_size}"
  vnet_cidr        = "${var.azure_vnet_cidr}"
  subnet_cidrs     = ["${var.azure_subnet_cidrs}"]

  custom_data = <<EOF
${data.template_file.base_install.rendered}
${data.template_file.consul_install.rendered}
${data.template_file.vault_install.rendered}
${data.template_file.nomad_install.rendered}
${data.template_file.bastion_quick_start.rendered}
${data.template_file.java_install.rendered}
${data.template_file.docker_install.rendered}
EOF
}

resource "azurerm_network_security_rule" "bastion_http" {
  name                        = "bastion_http"
  resource_group_name         = "${azurerm_resource_group.hashistack.name}"
  network_security_group_name = "${module.network_azure.security_group_name}"

  priority  = 1000
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_port_range     = "80"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "bastion_https" {
  name                        = "bastion_https"
  resource_group_name         = "${azurerm_resource_group.hashistack.name}"
  network_security_group_name = "${module.network_azure.security_group_name}"

  priority  = 1001
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_port_range     = "443"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "bastion_tcp_4646" {
  name                        = "bastion_tcp_4646"
  resource_group_name         = "${azurerm_resource_group.hashistack.name}"
  network_security_group_name = "${module.network_azure.security_group_name}"

  priority  = 1002
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_port_range     = "4646"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "bastion_tcp_8080" {
  name                        = "bastion_tcp_8080"
  resource_group_name         = "${azurerm_resource_group.hashistack.name}"
  network_security_group_name = "${module.network_azure.security_group_name}"

  priority  = 1003
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_port_range     = "8080"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "bastion_tcp_8200" {
  name                        = "bastion_tcp_8200"
  resource_group_name         = "${azurerm_resource_group.hashistack.name}"
  network_security_group_name = "${module.network_azure.security_group_name}"

  priority  = 1004
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_port_range     = "8200"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "bastion_tcp_8500" {
  name                        = "bastion_tcp_8500"
  resource_group_name         = "${azurerm_resource_group.hashistack.name}"
  network_security_group_name = "${module.network_azure.security_group_name}"

  priority  = 1005
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_port_range     = "8500"
  destination_address_prefix = "*"
}

module "hashistack_azure" {
  source                     = "git@github.com:hashicorp-modules/hashistack-azure.git//quick-start"
  name                       = "${var.name}"
  provider                   = "${var.provider}"
  environment                = "${var.environment}"
  local_ip_url               = "${var.local_ip_url}"
  admin_username             = "${var.admin_username}"
  admin_password             = "${var.admin_password}"
  admin_public_key_openssh   = "${module.ssh_key.public_key_openssh}"
  azure_region               = "${var.azure_region}"
  azure_asg_initial_vm_count = "${var.azure_asg_initial_vm_count}"
  azure_os                   = "${var.azure_os}"
  azure_vm_size              = "${var.azure_vm_size}"
  azure_subnet_id            = "${module.network_azure.subnet_ids[0]}"

  azure_vm_custom_data = <<EOF
${data.template_file.base_install.rendered}
${data.template_file.consul_install.rendered}
${data.template_file.vault_install.rendered}
${data.template_file.nomad_install.rendered}
${data.template_file.hashistack_quick_start.rendered}
${data.template_file.java_install.rendered}
${data.template_file.docker_install.rendered}
EOF
}
