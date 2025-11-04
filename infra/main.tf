# ecs-lab/main.tf

module "vpc" {
  source             = "./common_modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  tags               = { Project = "Terraform-VPC", Environment = var.environment }
}

module "security_groups" {
  source = "./common_modules/security"
  vpc_id = module.vpc.vpc_id
}

module "acm" {
  source          = "./common_modules/acm"
  domain_name     = var.domain_name
  route53_zone_id = aws_route53_zone.this.zone_id
  tags            = { Project = "Terraform-VPC", Environment = var.environment }
}

module "jenkins_server" {
  source        = "./common_modules/compute"
  subnet_id     = module.vpc.private_subnet_ids[0]
  private_sg_id = module.security_groups.private_sg_id
  key_name      = var.key_pair_name
}

module "ecr" {
  source               = "./common_modules/ecr"
  ecr_repository_names = var.ecr_repository_names
}

module "rds" {
  source                 = "./common_modules/rds"
  db_instance_identifier = "${var.rds_instance_identifier}-${var.environment}"
  db_name                = var.rds_db_name
  db_username            = var.rds_db_username
  db_password            = var.rds_db_password
  private_subnet_ids     = module.vpc.private_subnet_ids
  database_sg_id         = module.security_groups.database_sg_id
}

module "alb" {
  source                      = "./common_modules/alb"
  alb_name                    = "${var.alb_name}-${var.environment}"
  vpc_id                      = module.vpc.vpc_id
  public_subnet_ids           = module.vpc.public_subnet_ids
  public_sg_id                = module.security_groups.public_sg_id
  target_group_fe_name        = "${var.target_group_fe_name}-${var.environment}"
  target_group_be_name        = "${var.target_group_be_name}-${var.environment}"
  target_group_jenkins_name   = "${var.target_group_jenkins_name}-${var.environment}"
  certificate_arn             = module.acm.certificate_arn
  domain_name                 = var.domain_name
}

module "ecs_app" {
  source                = "./common_modules/ecs"
  depends_on            = [module.alb]
  cluster_name          = "${var.ecs_cluster_name}-${var.environment}"
  region                = var.region
  private_subnet_ids    = module.vpc.private_subnet_ids
  private_sg_id         = module.security_groups.private_sg_id
  target_group_be_arn   = module.alb.target_group_be_arn
  target_group_fe_arn   = module.alb.target_group_fe_arn
  ecr_image_backend     = "${module.ecr.ecr_repository_urls["backend"]}:latest"
  ecr_image_frontend    = "${module.ecr.ecr_repository_urls["frontend"]}:latest"
  backend_environment_variables = {
    ASPNETCORE_URLS = "http://+:80"
    DB_HOST         = module.rds.db_instance_endpoint
    DB_NAME         = var.rds_db_name
    DB_USERNAME     = var.rds_db_username
    DB_PASSWORD     = var.rds_db_password
  }
  frontend_environment_variables = {
    APP_API_HOST = module.alb.alb_dns_name
    APP_API_PORT = "80"
  }
}

resource "aws_route53_zone" "this" {
  name = var.domain_name
}

resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = module.alb.target_group_jenkins_arn
  target_id        = module.jenkins_server.instance_id
  port             = 8080
}

module "app_dns_record" {
  source         = "./common_modules/route53"
  zone_id        = aws_route53_zone.this.zone_id
  record_name    = var.domain_name
  alias_dns_name = module.alb.alb_dns_name
  alias_zone_id  = module.alb.alb_zone_id
}

module "jenkins_dns_record" {
  source         = "./common_modules/route53"
  zone_id        = aws_route53_zone.this.zone_id
  record_name    = "jenkins.${var.domain_name}"
  alias_dns_name = module.alb.alb_dns_name
  alias_zone_id  = module.alb.alb_zone_id
}