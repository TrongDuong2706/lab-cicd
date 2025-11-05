
# --- CloudWatch Log Groups ---
# Tạo nhóm log để thu thập log từ container backend
resource "aws_cloudwatch_log_group" "backend" {
  # Tên log group, theo quy ước chung của AWS
  name              = "/ecs/${var.cluster_name}/backend"
  
  # Tự động xóa log sau 7 ngày để tiết kiệm chi phí
  retention_in_days = 7 

  tags = {
    Name = "${var.cluster_name}-backend-logs"
  }
}

# Tạo nhóm log để thu thập log từ container frontend
resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.cluster_name}/frontend"
  retention_in_days = 7

  tags = {
    Name = "${var.cluster_name}-frontend-logs"
  }
}

# --- ECS Cluster ---
# Tạo ECS Cluster để quản lý các service và task
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# --- IAM Role cho ECS Task Execution ---
# Role này cho phép ECS agent thay mặt bạn thực hiện các hành động
# như kéo image từ ECR và gửi log đến CloudWatch.
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.cluster_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Gán policy được quản lý bởi AWS cho role vừa tạo
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# --- ECS Task Definitions ---
# Định nghĩa cho task backend
resource "aws_ecs_task_definition" "backend" {
  family                   = "backend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend-container"
      image     = var.ecr_image_backend
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.backend.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "backend"
        }
      }
      environment = [
        for name, value in var.backend_environment_variables : {
          name  = name
          value = value
        }
      ]
    }
  ])
}

# Định nghĩa cho task frontend
resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "frontend-container"
      image     = var.ecr_image_frontend
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.frontend.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "frontend"
        }
      }
      environment = [
        for name, value in var.frontend_environment_variables : {
          name  = name
          value = value
        }
      ]
    }
  ])
}

# --- ECS Services ---
# Tạo service để chạy và duy trì số lượng task backend mong muốn
resource "aws_ecs_service" "backend" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.private_sg_id]
  }

  load_balancer {
    target_group_arn = var.target_group_be_arn
    container_name   = "backend-container"
    container_port   = 80
  }

  # Đảm bảo Terraform chờ cho đến khi service ổn định
  wait_for_steady_state = true
}

# Tạo service để chạy và duy trì số lượng task frontend mong muốn
resource "aws_ecs_service" "frontend" {
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.private_sg_id]
  }

  load_balancer {
    target_group_arn = var.target_group_fe_arn
    container_name   = "frontend-container"
    container_port   = 80
  }

  # Đảm bảo Terraform chờ cho đến khi service ổn định
  wait_for_steady_state = true
}
