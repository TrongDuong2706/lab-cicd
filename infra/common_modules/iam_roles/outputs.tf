# common_modules/iam_jenkins/outputs.tf

output "controller_instance_profile_name" {
  description = "Tên của Instance Profile để gắn vào EC2 Jenkins."
  value       = aws_iam_instance_profile.jenkins_controller_profile.name
}

output "agent_role_arn" {
  description = "ARN của IAM Role để các ECS Agent Task sử dụng."
  value       = aws_iam_role.jenkins_agent_role.arn
}