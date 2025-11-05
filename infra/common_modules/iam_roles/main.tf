# ------------------------------------------------------------------
#  1. ROLE CHO JENKINS AGENT (ECS TASK)
# ------------------------------------------------------------------
resource "aws_iam_role" "jenkins_agent_role" {
  name = "jenkins-agent-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "agent_policy" {
  name = "JenkinsAgentPolicy"
  role = aws_iam_role.jenkins_agent_role.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [ "ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:GetRepositoryPolicy", "ecr:DescribeRepositories", "ecr:ListImages", "ecr:DescribeImages", "ecr:BatchGetImage", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload", "ecr:PutImage" ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = [ "s3:GetObject", "s3:PutObject", "s3:ListBucket" ],
        Resource = "*"
      }
    ]
  })
}

# ------------------------------------------------------------------
#  2. ROLE CHO JENKINS CONTROLLER (MÁY CHỦ EC2)
# ------------------------------------------------------------------
resource "aws_iam_role" "jenkins_controller_role" {
  name = "jenkins-controller-role-${var.environment}"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "controller_policy" {
  name = "JenkinsControllerPolicy"
  role = aws_iam_role.jenkins_controller_role.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [ "ecs:*", "ecr:*" ],
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "iam:PassRole",
        Resource = aws_iam_role.jenkins_agent_role.arn
      },
      {
        Effect   = "Allow",
        Action   = [ "ec2:Describe*", "iam:ListInstanceProfiles" ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "controller_ssm_attachment" {
  role       = aws_iam_role.jenkins_controller_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# --- THÊM KHỐI NÀY VÀO ---
# Cấp quyền cho Jenkins Controller để có thể thực hiện các hành động của Task Execution Role
# (Vì giao diện Jenkins của bạn không có ô Task Execution Role ARN riêng)
resource "aws_iam_role_policy_attachment" "controller_task_execution_attachment" {
  role       = aws_iam_role.jenkins_controller_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# -------------------------

# ------------------------------------------------------------------
#  3. INSTANCE PROFILE (Bắt buộc để gắn Role vào EC2)
# ------------------------------------------------------------------
resource "aws_iam_instance_profile" "jenkins_controller_profile" {
  name = "jenkins-controller-profile-${var.environment}"
  role = aws_iam_role.jenkins_controller_role.name
}