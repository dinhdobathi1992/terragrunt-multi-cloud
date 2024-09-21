include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/azure//resource-group"
}

inputs = {
  site_name                              = "US"
  location                               = "East US 2"
  resource_group_name                    = "app-terraform-test"
  deployment_storage_resource_group_name = "deployment"
  deployment_storage_account_name        = "deploymentstate"
}