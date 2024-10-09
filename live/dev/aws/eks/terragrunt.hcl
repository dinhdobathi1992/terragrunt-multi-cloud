terraform {
  source = "git::git@github.com:gruntwork-io/terraform-fake-modules.git//modules/aws/eks?ref=example"
}

dependency aws_vpc_production_use1 {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    id = "vpc-fake1234"
  }
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}





inputs = {
  vpc_id = dependency.aws_vpc_production_use1.outputs.id
}
