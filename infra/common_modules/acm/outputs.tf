output "certificate_arn" {
  description = "ARN của chứng chỉ ACM đã được xác thực."
  value       = aws_acm_certificate_validation.this.certificate_arn
}