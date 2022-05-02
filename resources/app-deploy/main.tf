module "app-deploy" {
  source = "../../modules/ec2"
  asg_name = "pet-clinic-app-servers"
  instance_type = "t2.micro"
  key_name = "devops"
  max = "1"
  min = "1"
  service_name = "petclinic-api"
  vpc_name     = "pclinic-name"
  subnet_ids = data.aws_subnet_ids.private_subnet_ids.ids
  security_group_id =  [aws_security_group.instance_sg.id]
  ec2_tag = "petclinic-api"
  user_data = data.template_file.app.rendered
}

module "pipeline" {
  source = "../../modules/ec2"
  asg_name = "pet-clinic-pipeline"
  instance_type = "t2.micro"
  key_name = "devops"
  max = "1"
  min = "1"
  service_name = "petclinic-pipeline"
  vpc_name     = "pclinic-name"
  subnet_ids = data.aws_subnet_ids.public_subnet_ids.ids
  security_group_id = [aws_security_group.instance_sg.id]
  ec2_tag = "petclinic-pipeline"
  user_data = data.template_file.pipeline.rendered
}

resource "aws_security_group" "instance_sg" {
  name   = "pipeline-instance"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  ingress {
    from_port   = 8080
    protocol    = "TCP"
    to_port     = 8080
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "pipeline-instance-sg"
  }
}

module "alb" {
  source = "../../modules/alb"
  security_groups = [aws_security_group.instance_sg.id]
  subnets = data.aws_subnet_ids.public_subnet_ids.ids
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_alb_target_group_attachment" "attach_ec2" {
  target_group_arn = module.alb.target_arn
  target_id        = module.app-deploy.private_instance_ids_app
}