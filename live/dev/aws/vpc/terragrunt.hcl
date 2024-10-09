include {
  path = find_in_parent_folders()
}

terraform {
  #source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v2.18.0"
  source = "${get_parent_terragrunt_dir()}/modules/aws//vpc"
}


###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.18.0?tab=inputs
###########################################################
inputs = {
  name = "my-vpc2"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }

}
