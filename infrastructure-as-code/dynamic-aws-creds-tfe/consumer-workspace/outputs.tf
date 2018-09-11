output "zREADME" {
  value = <<README
Success! You provisioned EC2 instance ${module.consumer_workspace.instance_id}
README
}
