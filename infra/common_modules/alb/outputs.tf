output "alb_dns_name" {
  description = "Tên DNS của Application Load Balancer."
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID của Load Balancer."
  value       = aws_lb.main.zone_id
}

output "target_group_fe_arn" {
  description = "ARN của target group frontend."
  value       = aws_lb_target_group.frontend.arn
}

output "target_group_be_arn" {
  description = "ARN của target group backend."
  value       = aws_lb_target_group.backend.arn
}
output "target_group_jenkins_arn" {
  description = "ARN của Target Group Jenkins."
  value       = aws_lb_target_group.jenkins.arn
}