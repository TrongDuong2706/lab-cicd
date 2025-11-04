variable "zone_id" {
  description = "ID của Hosted Zone trong Route 53."
  type        = string
}

variable "record_name" {
  description = "Tên của bản ghi (ví dụ: yourdomain.com)."
  type        = string
}

variable "alias_dns_name" {
  description = "Tên DNS của tài nguyên đích (ALB DNS name)."
  type        = string
}

variable "alias_zone_id" {
  description = "Zone ID của tài nguyên đích (ALB zone ID)."
  type        = string
}