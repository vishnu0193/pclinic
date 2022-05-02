
data "aws_vpc" "vpc" {
  tags = {
    Name = "pclinic-name"
  }
}



