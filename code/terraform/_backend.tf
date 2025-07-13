terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = local.region
  assume_role {
    role_arn     = "arn:aws:iam::291705473768:role/tf-deployment-role"
    session_name = "tf-deploy"
  }
}
terraform {
  backend "s3" {
    bucket       = "tf-anaoum-lab-terraform-storage"
    key          = "terraform_state/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
