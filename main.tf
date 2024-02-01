locals {
  # This local is used to define the organization name.
  organization_name = "ConseilsTI"
}

# -----------------------------------------------------------------------------
# The following code block is used to create Terraform Cloud Policies.
# -----------------------------------------------------------------------------

locals {
  # This local is used to define the folder where all the policies are located.
  # The folder structure should be like this:
  # policies
  # |_ global
  #    <policy name>.sentinel
  #   |_ test
  #     |_ <policy_name>
  #        <test name>.hcl
  #        <mock name>.sentinel
  policies_folder = "policies"

  # This local is used to get a list of all folder inside the policies folder.
  files = fileset(local.policies_folder, "*/*.sentinel")
}

resource "tfe_policy" "this" {
  for_each = local.files
  name     = element(split(".", element(split("/", each.key), 1)), 2)
  # description  = ""
  organization = local.organization_name
  kind         = "sentinel"
  policy       = file("${local.policies_folder}/${each.key}")
  enforce_mode = "advisory" # advisory, hard-mandatory and soft-mandatory
}

# -----------------------------------------------------------------------------
# The following code block is used to create Terraform Cloud Policy Sets.
# -----------------------------------------------------------------------------

resource "tfe_policy_set" "global" {
  name         = "Global-Policy-Set"
  description  = "This policy-set is assigned at the organization level."
  organization = local.organization_name
  global       = true
  kind         = "sentinel"
  policy_ids   = [for value in tfe_policy.this : value.id]
}


locals {
  raw_lines = [
    for line in split("\n", file("./policies/global/allowed-providers.sentinel")) :
    line
  ]
  first_blank_line = index(local.raw_lines, "")
  description_lines = slice(local.raw_lines, 0, local.first_blank_line)
  updated_description_lines = [
    for line in local.description_lines : 
    trimspace(replace(line, "#", ""))
  ]
  description = join( " ", local.updated_description_lines)
}

output "raw_lines" {
  value = local.raw_lines
}

output "first_blank_line" {
  value = local.first_blank_line
}

output "description_lines" {
  value = local.description_lines
}

output "description" {
  value = local.description
}