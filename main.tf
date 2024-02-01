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

module "description" {
  for_each = local.files
  source   = "./modules/get_description"
  path     = each.value
}

resource "tfe_policy" "this" {
  for_each     = local.files
  name         = element(split(".", element(split("/", each.key), 1)), 2)
  description  = module.description[each.value].description
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
