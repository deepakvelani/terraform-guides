output "backend" {
  value = "${vault_aws_secret_backend.consumer.path}"
}

output "role" {
  value = "${vault_aws_secret_backend_role.consumer.name}"
}

output "vault_addr" {
  value = "${format("%s%s:8200", var.vault_protocol, module.vault.vault_lb_dns)}"
}

output "vault_readme" {
  value = "${module.vault.zREADME}"
}
