# ---------------------------------------------------------------------------------------------------------------------
# General Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name to use on all of the resources."
  type        = "string"
}

variable "provider" {
  description = "Provider name to be used in the templated scripts run as part of cloud-init"
  type        = "string"
  default     = "azure"
}

variable "environment" {
  description = "Name of the environment for resource tagging (ex: dev, prod, etc)."
  default     = "demo"
}

variable "local_ip_url" {
  description = "The URL to use to get a resource's IP address at runtime."
  type        = "string"
  default     = "http://checkip.amazonaws.com"
}

variable "admin_username" {
  description = "The username to use for each VM."
  type        = "string"
  default     = "hashistack"
}

variable "admin_password" {
  description = "The password to use for each VM."
  type        = "string"
  default     = "pTFE1234!"
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "azure_client_id" {
  description = "TODO"
}

variable "azure_client_secret" {
  description = "TODO"
}

variable "azure_subscription_id" {
  description = "TODO"
}

variable "azure_tenant_id" {
  description = "TODO"
}

variable "azure_region" {
  description = "The Azure Region to use for all resources (ex: eastus, westus)."
  type        = "string"
  default     = "eastus"
}

variable "azure_asg_initial_vm_count" {
  description = "TODO"
  type        = "string"
  default     = "3"
}

variable "azure_os" {
  description = "The operating system to use on each VM."
  type        = "string"

  #################################################################################
  # Do not change for now, as only a few Linux versions support cloud-init for now 
  # https://docs.microsoft.com/en-us/azure/virtual-machines/linux/using-cloud-init
  #################################################################################
  default = "ubuntu"
}

variable "azure_vm_size" {
  description = "The size to use for each VM."
  type        = "string"
  default     = "Standard_DS1_V2"
}

variable "azure_vnet_cidr" {
  description = "The public network CIDRs to add to the virtual network."
  type        = "string"
  default     = "172.31.0.0/16"
}

variable "azure_subnet_cidrs" {
  description = "The public network CIDRs to add to the subnet."
  type        = "list"
  default     = ["172.31.0.0/20"]
}

# ---------------------------------------------------------------------------------------------------------------------
# HashiStack Variables
# ---------------------------------------------------------------------------------------------------------------------
variable "hashistack_consul_version" {
  description = "The version number of Consul to install on the VM at runtime."
  default     = "1.2.3"
}

variable "hashistack_vault_version" {
  description = "The version number of Vault to install on the VM at runtime."
  default     = "0.11.3"
}

variable "hashistack_nomad_version" {
  description = "The version number of Nomad to install on the VM at runtime."
  default     = "0.8.6"
}

variable "hashistack_consul_url" {
  description = "URL to download Consul version if internet not accessible."
  default     = ""
}

variable "hashistack_vault_url" {
  description = "URL to download Vault version if internet not accessible."
  default     = ""
}

variable "hashistack_nomad_url" {
  description = "URL to download Nomad version if internet not accessible."
  default     = ""
}

variable "consul_server_config_override" {
  description = "Any additional Consul server coonfiguration to override defaults."
  default     = ""
}

variable "consul_client_config_override" {
  description = "Any additional Consul client coonfiguration to override defaults."
  default     = ""
}

variable "vault_config_override" {
  description = "Any additional Vault coonfiguration to override defaults."
  default     = ""
}

variable "nomad_config_override" {
  description = "Any additional Nomad coonfiguration to override defaults."
  default     = ""
}
