
resource "aws_launch_configuration" "web_server" {
  name_prefix   = "pet-clinic-launch-config"
  image_id      = "ami-0f9fc25dd2506cf6d"
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = var.security_group_id
  lifecycle {
    create_before_destroy = true
  }
  user_data = var.user_data
}

resource "aws_autoscaling_group" "web_server_groups" {
  name                 = var.asg_name
  launch_configuration = aws_launch_configuration.web_server.name
  min_size             = var.min
  max_size             = var.max
  vpc_zone_identifier = var.subnet_ids

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = var.ec2_tag
    propagate_at_launch = true
  }

}
data "aws_instance" "webapp-ec2" {
  filter {
    name   = "tag:Name"
    values = ["petclinic-api"]
  }
  depends_on = [aws_autoscaling_group.web_server_groups]
}
output "private_instance_ids_app" {
  value = data.aws_instance.webapp-ec2.id
}
