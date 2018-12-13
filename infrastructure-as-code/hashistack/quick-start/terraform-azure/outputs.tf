output "zREADME" {
  description = "Full README for interacting with the Hashistack resources."
  value       = "${module.hashistack_azure.zREADME}"
}

output "bastion_fqdn" {
  value = "${element(concat(module.network_azure.bastion_fqdns, list("")), 0)}"
}

output "lb_fqdn" {
  value = "${module.hashistack_azure.lb_fqdn}"
}

output "lb_public_ip" {
  value = "${module.hashistack_azure.lb_public_ip_address}"
}

output "asg_ssh_string" {
  value = "${module.hashistack_azure.quick_ssh_string}"
}
