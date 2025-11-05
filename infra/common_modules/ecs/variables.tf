# common_modules/ecs/variables.tf

variable "cluster_name" {
  description = "Name for the ECS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ECS services"
  type        = list(string)
}

variable "private_sg_id" {
  description = "ID of the private security group for the ECS services"
  type        = string
}

# --- Biến cho Task Definition & Service của Backend ---
variable "ecr_image_backend" {
  description = "Full URI of the backend ECR image"
  type        = string
}

variable "backend_environment_variables" {
  description = "A map of environment variables for the backend container"
  type        = map(string)
  default     = {}
}

variable "target_group_be_arn" {
  description = "ARN of the backend target group for the load balancer"
  type        = string
}

# --- Biến cho Task Definition & Service của Frontend ---
variable "ecr_image_frontend" {
  description = "Full URI of the frontend ECR image"
  type        = string
}

variable "frontend_environment_variables" {
  description = "A map of environment variables for the frontend container"
  type        = map(string)
  default     = {}
}

variable "target_group_fe_arn" {
  description = "ARN of the frontend target group for the load balancer"
  type        = string
}

variable "region" {
  description = "AWS Region để triển khai tài nguyên"
  type        = string
}
