output "instance_id" {
  description = "ID của EC2 instance Jenkins."
  value = aws_instance.jenkins.id
}