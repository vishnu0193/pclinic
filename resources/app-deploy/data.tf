data "aws_vpc" "vpc" {
  tags = {
    Name = "pclinic-name"
  }
}

data "aws_subnet_ids" "public_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    SubnetType = "Public"
  }
}

data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    SubnetType = "Private"
  }
}

data "template_file" "pipeline" {
  template = file("${path.module}/userdata_pipeline.sh")
}

data "template_file" "app" {
  template = file("${path.module}/userdata_appdeploy.sh")
}