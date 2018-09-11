output "zREADME" {
  value = <<README
After your first apply, re-initialize Terraform with your newly created workspace
backend so you can begin using it for remote state. A file named `tfe.tf` has
been placed locally which contains the "remote" backend Terraform provider block.
This new provider block will allow you to run the below init command to initialize
the enhanced remote backend for TFE.

Remove the `tfe.tf` file if you want to switch back to local state.

Note that normally you would _not_ pass the `token` in via the CLI, but
for the sake of simplicity in this example, we are doing that below.

See below best practices for configuring the backend.

https://www.terraform.io/docs/backends/config.html
https://www.terraform.io/docs/backends/types/remote.html#configuration-variables

```
  $ terraform init \
        -backend=true \
        -reconfigure=true \
        -backend-config="organization=${tfe_organization.org.id}" \
        -backend-config="token=${tfe_team_token.producer.token}" \
        -backend-config="workspaces=[{name=\"${tfe_workspace.producer.name}\"}]"
```

You will see the below prompt, enter `yes`.

```
Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "remote" backend. No existing state was found in the newly
  configured "remote" backend. Do you want to copy this state to the new "remote"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes
```

Now head over to the Consumer workspace in a new terminal.

  $ cd ../consumer-workspace

Set the below environment variables in the Consumer workspace.

  ${format("export TF_VAR_tfe_org_name=%s", tfe_organization.org.name)}
  ${format("export TF_VAR_tfe_consumer_workspace=%s", tfe_workspace.consumer.name)}
  ${format("export TF_VAR_tfe_consumer_token=%s", tfe_team_token.consumer.token)}
  ${format("export TF_VAR_tfe_producer_workspace=%s", tfe_workspace.producer.name)}


Initialize the enhanced remote backend.

```
  $ terraform init \
        -backend=true \
        -backend-config="organization=${tfe_organization.org.id}" \
        -backend-config="token=${tfe_team_token.consumer.token}" \
        -backend-config="workspaces=[{name=\"${tfe_workspace.consumer.name}\"}]"
```

Run a plan

  $ terraform plan

Then run the apply through TFE by going to the plan URL output.

${module.producer_workspace.vault_readme}
README
}

# Remote state outputs for consumer
output "backend" {
  value = "${module.producer_workspace.backend}"
}

output "role" {
  value = "${module.producer_workspace.role}"
}

output "tfe_oauth_token" {
  value = "${data.template_file.tfe_oauth_token.rendered}"
}
