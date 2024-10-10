# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load site-level variables
  site_vars = read_terragrunt_config(find_in_parent_folders("site.hcl"))

  # Extract the variables we need for easy access
  subscription_id                        = local.env_vars.locals.subscription_id
  #client_id                              = local.env_vars.locals.client_id
  tenant_id                              = local.env_vars.locals.tenant_id
  deployment_storage_resource_group_name = local.site_vars.locals.deployment_storage_resource_group_name
  deployment_storage_account_name        = local.site_vars.locals.deployment_storage_account_name
}

# Generate an Azure provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
  use_oidc = true
  use_cli = false
  client_id       = "2305e6da-66f9-4c84-8701-96b513c5b377"
  subscription_id = "48fb7099-61a3-4f06-9082-78beba63a820"
  tenant_id       = "23131c9d-5769-486a-851b-18c604ca85cf"
  oidc_token_file_path  = "/mnt/efs/oidc-token"
}
EOF
}


terraform {
  # Force Terraform to keep trying to acquire a lock for
  # up to 20 minutes if someone else already has the lock
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.env_vars.locals,
  local.site_vars.locals
)
