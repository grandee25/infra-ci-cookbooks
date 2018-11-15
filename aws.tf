provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "example" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  key_name = "infra-ci-cookbooks"
  vpc_security_group_ids = ["${aws_security_group.test.id}"]
  tags { Name = "webapp" }
  provisioner "local-exec" {
     command = "echo ${aws_instance.example.public_ip} ${aws_instance.example.public_dns} >> hosts.txt"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

resource "aws_security_group" "test" {
  name = "test"
  description = "test"
  vpc_id = "vpc-4ea39926"
}

resource "aws_security_group_rule" "for_test" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.test.id}"
}
