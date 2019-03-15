# Vault Policy file for user corrigan

# Access to secret/corrigan
path "secret/roger/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Ability to change password
path "auth/userpass/users/corrigan/password" {
  capabilities = ["update"]
}

# Ability to see their own policy
path "sys/policies/acl/corrigan" {
  capabilities = ["read"]
}

# Additional access for UI
path "secret/" {
  capabilities = ["list"]
}
path "secret/corrigan" {
  capabilities = ["list"]
}
path "sys/mounts" {
  capabilities = ["read", "list"]
}
path "sys/policies/acl/" {
  capabilities = ["list"]
}

# Ability to provision Kubernetes auth backends
path "sys/auth/corrigan*" {
  capabilities = ["sudo", "create", "read", "update", "delete", "list"]
}
path "sys/auth" {
  capabilities = ["read", "list"]
}
path "auth/corrigan*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Needed for the Terraform Vault Provider
path "auth/token/create" {
  capabilities = ["create", "read", "update", "list"]
}
