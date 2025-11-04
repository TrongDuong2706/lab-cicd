# ecs-lab/terraform.tfvars

# Cấu hình chung
region             = "ap-southeast-1"
availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]

# Cấu hình mạng (VPC)
vpc_cidr          = "10.0.0.0/16"
public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets   = ["10.0.3.0/24", "10.0.4.0/24"]

# Cấu hình ECR
ecr_repository_names = ["frontend", "backend"]

# Cấu hình ECS
ecs_cluster_name = "my-ecs-cluster"

# Cấu hình RDS - THAY THẾ BẰNG THÔNG TIN CỦA BẠN
rds_instance_identifier = "mydb"
rds_db_name             = "mydatabase"
rds_db_username         = "postgres"
rds_db_password         = "Pa$$w0rd"

# Cấu hình ALB
alb_name               = "my-alb"
target_group_fe_name   = "frontend-tg"
target_group_be_name   = "backend-tg"

# Biến môi trường cho Frontend
# LƯU Ý: Biến này thực tế không cần thiết ở đây nữa vì giá trị được
# tạo động trong ecs_services.tf. Bạn có thể xóa nó đi.
# Giữ lại nếu bạn có mục đích sử dụng khác.
fe_app_api_host = ""


domain_name= "trongduong.website"
environment = "uat"
