# common_modules/iam_jenkins/outputs.tf

output "controller_instance_profile_name" {
  description = "Tên của Instance Profile để gắn vào EC2 Jenkins."
  value       = aws_iam_instance_profile.jenkins_controller_profile.name
}

