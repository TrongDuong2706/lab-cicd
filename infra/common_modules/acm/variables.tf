variable "domain_name" {
  description = "Tên miền chính để tạo chứng chỉ (ví dụ: yourdomain.com)."
  type        = string
}

variable "route53_zone_id" {
  description = "ID của Hosted Zone trong Route 53."
  type        = string
}

variable "tags" {
  description = "Các tags để gán cho tài nguyên."
  type        = map(string)
  default     = {}
}