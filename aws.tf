provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "ami-0f65671a86f061fcd"
  instance_type = "t2.micro"
  key_name = "infra-ci-cookbooks"
  vpc_security_group_ids = ["${aws_security_group.test.id}"]
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
