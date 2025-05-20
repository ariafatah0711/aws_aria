# resource security group
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "web_linktree" {
  description = "Link to the deployed web page"
  value       = "http://${aws_instance.app_server.public_ip}"
}