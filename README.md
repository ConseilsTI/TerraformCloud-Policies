<!-- BEGIN_TF_DOCS -->
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

* Set the `TFE_TOKEN` environment variable: The provider can read the TFE\_TOKEN
environment variable and the token stored there to authenticate. Refer to
[Managing Variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables) documentation for more details.

## Features

* Manages configuration and life-cycle of Terraform Cloud resources:
  * policies
  * policy sets

## Test Folder Structure

Sentinel is opinionated about the folder structure required for tests. This
opinionated structure allows testing to be as simple as running sentinel
test with no arguments. Additionally, it becomes simple to test in a CI or
add new policies.

The structure Sentinel expects is test/<policy>/*.[hcl|json] where <policy>
is the name of your policy file without the file extension. Within that
folder is a list of HCL or JSON files. Each file represents a single test
case. Therefore, each policy can have multiple tests associated with it.
Sentinel

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (> 1.6.0)

- <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) (~>0.51)

## Modules

The following Modules are called:

### <a name="module_description"></a> [description](#module\_description)

Source: ./modules/get_description

Version:

## Required Inputs

The following input variables are required:

### <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name)

Description: The name of the Terraform Cloud organization.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_policies_folder"></a> [policies\_folder](#input\_policies\_folder)

Description: The name of the folder where policies are located.

Type: `string`

Default: `"./policies"`

## Resources

The following resources are used by this module:

- [tfe_policy.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/policy) (resource)
- [tfe_policy_set.global](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/policy_set) (resource)

## Outputs

No outputs.

<!-- markdownlint-disable first-line-h1 -->
------
>This GitHub repository is manage through Terraform Code from [TerraformCloud-Foundation](https://github.com/benyboy84/TerraformCloud-Foundation) repository.
<!-- END_TF_DOCS -->