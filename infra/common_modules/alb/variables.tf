variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "public_sg_id" {
  description = "ID of the public security group"
  type        = string
}

variable "target_group_fe_name" {
  description = "Name of the frontend target group"
  type        = string
}

variable "target_group_be_name" {
  description = "Name of the backend target group"
  type        = string
}

variable "certificate_arn" {
  description = "ARN của chứng chỉ SSL từ ACM để sử dụng cho listener HTTPS."
  type        = string
}

variable "domain_name" { type = string }

variable "target_group_jenkins_name" { type = string }
