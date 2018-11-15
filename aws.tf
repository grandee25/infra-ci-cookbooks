provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "ami-0f65671a86f061fcd"
  instance_type = "t2.micro"
  key_name = "infra-ci-cookbooks"
}

#resource "aws_eip" "ip" {
#  instance = "${aws_instance.example.id}"
#}
