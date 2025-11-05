# ecs-lab/terraform.tfvars

# Cấu hình chung
region             = "ap-southeast-1"
availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
domain_name        = "trongduong.website"
environment        = "dev"
key_pair_name      = "lab-cicd" 
fe_app_api_host = ""


# Cấu hình mạng (VPC)
vpc_cidr          = "10.0.0.0/16"
public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets   = ["10.0.3.0/24", "10.0.4.0/24"]

# Cấu hình ECR
ecr_repository_names = ["frontend", "backend", "jenkins-agent"]

# Cấu hình ECS
ecs_cluster_name = "my-ecs-cluster"

# Cấu hình RDS
rds_instance_identifier = "mydb"
rds_db_name             = "mydatabase"
rds_db_username         = "postgres"
rds_db_password         = "Pa$$w0rd"

# Cấu hình ALB
alb_name                    = "my-alb"
target_group_fe_name        = "frontend-tg"
target_group_be_name        = "backend-tg"
target_group_jenkins_name   = "jenkins-tg"