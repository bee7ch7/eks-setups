include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_config = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment        = local.environment_config.locals.environment
}

terraform {
  source = "../../../../../modules/aws_security_groups//."
}

dependency "vpc" {
  config_path                             = "../../vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"]
  mock_outputs = {
    vpc_id = "vpc_id"
  }
}

inputs = {
  environment = local.environment
  vpc_id      = dependency.vpc.outputs.vpc_id
  name        = "eks-remote-access",
  ports_in = [
    {
      protocol         = "tcp"
      from_port        = "1",
      to_port          = "65535",
      cidr_blocks      = [],
      ipv6_cidr_blocks = [],
      security_groups  = []
    }
  ],

  # egress
  ports_out = {
    cidr_blocks      = [],
    ipv6_cidr_blocks = []
  }
}
