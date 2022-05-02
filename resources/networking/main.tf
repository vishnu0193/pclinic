module "networking" {
  source = "../../modules/network"

  availability_zones =  ["us-east-1a", "us-east-1b"]
  private_subnets    = ["172.20.20.0/24", "172.20.40.0/24"]
  public_subnets     = ["172.20.10.0/24", "172.20.30.0/24"]
  vpc_cidr           = "172.20.0.0/16"
  vpc_name           = "pclinic-name"
}
