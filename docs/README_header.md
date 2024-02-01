# Terraform Cloud Policies

Code which manages configuration and life-cycle of all the Terraform Cloud
Policies. It is designed to be used from a dedicated VCS-Driven Terraform
Cloud workspace that would provision and manage the policies using
Terraform code (IaC).

## Permissions

To manage the resources from that code, provide a token from an account with
`manage policies` permissions. Alternatively, you can use a token from a team
instead of a user token.

## Authentication

The Terraform Cloud provider requires a Terraform Cloud/Enterprise API token in
order to manage resources.

* Set the `TFE_TOKEN` environment variable: The provider can read the TFE_TOKEN
environment variable and the token stored there to authenticate. Refer to
[Managing Variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables) documentation for more details.

## Features

* Manages configuration and life-cycle of Terraform Cloud resources:
  * policies
  * policy sets
