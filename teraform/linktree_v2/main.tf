# resource utama, seperti EC2 dan VPC
resource "aws_instance" "app_server" {
  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t2.micro"
  key_name               = "ariaf"
  vpc_security_group_ids = [aws_security_group.web_ssh.id]
  user_data              = file("${path.module}/user_data.sh")

  tags = {
    Name = var.instance_name
  }
}