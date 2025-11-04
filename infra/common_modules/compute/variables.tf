variable "subnet_id" {
  description = "ID của một private subnet để đặt Jenkins vào."
  type        = string
}

variable "private_sg_id" {
  description = "ID của Security Group private, nơi Jenkins sẽ được đặt."
  type        = string
}

variable "key_name" {
  description = "Tên của Key Pair để truy cập EC2."
  type        = string
}

variable "ami_id" {
  description = "AMI ID cho EC2 Jenkins."
  type        = string
  default     = "ami-0827b3068f1548bf6" 
}