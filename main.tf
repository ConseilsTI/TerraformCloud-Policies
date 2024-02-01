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

  # Read file content to get all lines.
  raw_lines = [
    for line in split("\n", file("./policies/global/allowed-providers.sentinel")) :
    line if startswith(line, "#") || startswith(line, "")
  ]

  # Get the index of the first blank line.
  # The description should be solid text followed by a blank line. 
  index = index(local.raw_lines, "")

  # Extract description line from the entire file.
  # The description should starts on the first line of the file and finish with the blank line identify in the index.
  description_lines = slice(local.raw_lines, 0, local.index)
  
  # A commented line must begin with the "#" symbol.
  # Because we don't want that symbol in the description, it is removed from each line.
  uncommented_lines = [
    for line in local.description_lines : 
    trimspace(trimprefix(line, "#"))
  ]

  # The description can be written on multiple line.
  # Because of that, we need to join every line into a single string for the description.
  description = join( " ", local.uncommented_lines)
}

output "raw_lines" {
  value = local.raw_lines
}

output "index" {
  value = local.index
}

output "description" {
  description = "The description of the Sentinel policy file."
  value       = local.description
}