variable "instance_type" {
  type = string

}

variable "key_name" {
  type = string

}


variable "min" {
  type = string
}

variable "max" {
  type = string
}

variable "vpc_name" {}

variable "subnet_ids" {
  type = list(string)
}
#
#variable "target_port" {
#  default = 80
#}

variable "service_name" {
  type = string
}

variable "security_group_id" {
  type = list(string)
}

variable "ec2_tag" {}

variable "asg_name" {}

variable "user_data" {
  type = string
}