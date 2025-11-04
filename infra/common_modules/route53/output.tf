output "record_fqdn" {
  description = "Tên miền đầy đủ của bản ghi đã được tạo."
  value       = aws_route53_record.this.fqdn
}