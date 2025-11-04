# ecs-lab/variables.tf

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of CIDR blocks for the public subnets."
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of CIDR blocks for the private subnets."
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of Availability Zones to deploy resources into."
}

# Biến cho ECR
variable "ecr_repository_names" {
  description = "List of ECR repository names"
  type        = list(string)
}

# Biến cho ECS
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

# Biến cho RDS
variable "rds_instance_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "rds_db_name" {
  description = "Name of the database"
  type        = string
}

variable "rds_db_username" {
  description = "Username for the database"
  type        = string
}

variable "rds_db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

# Biến cho ALB
variable "alb_name" {
  description = "Name of the Application Load Balancer"
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

# Biến môi trường
variable "fe_app_api_host" {
  description = "API host for the frontend application. This is now informational as the value is dynamically generated."
  type        = string
}

variable "domain_name" {
  description = "Tên miền bạn muốn cấu hình SSL, ví dụ: myapp.com"
  type        = string
}

variable "environment" {
  description = "Tên Environment, ví dụ: dev, uat, prod"
  type        = string
}


variable "target_group_jenkins_name" {
  description = "Tên cho Target Group của Jenkins."
  type        = string
  default     = "jenkins-tg"
}


variable "key_pair_name" {
  description = "Tên Key Pair đã tạo trong AWS để truy cập EC2."
  type        = string
}
