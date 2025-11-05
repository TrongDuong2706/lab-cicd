# ------------------------------------------------------------------
#  CHỈ CẦN MỘT ROLE DUY NHẤT CHO JENKINS CONTROLLER (MÁY CHỦ EC2)
# ------------------------------------------------------------------
resource "aws_iam_role" "jenkins_controller_role" {
  name = "jenkins-controller-role-${var.environment}"

  # Chính sách tin cậy: Cho phép EC2 đảm nhận role này
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Gắn policy tùy chỉnh (inline) chứa tất cả các quyền cần thiết
resource "aws_iam_role_policy" "controller_policy" {
  name = "JenkinsControllerPolicy"
  role = aws_iam_role.jenkins_controller_role.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        # Quyền để push/pull image từ ECR và update ECS Service
        Effect   = "Allow",
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ],
        Resource = "*"
      }
    ]
  })
}

# Gắn policy SSM được quản lý bởi AWS để có thể dùng Session Manager
resource "aws_iam_role_policy_attachment" "controller_ssm_attachment" {
  role       = aws_iam_role.jenkins_controller_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ------------------------------------------------------------------
#  INSTANCE PROFILE (Vẫn bắt buộc để gắn Role vào EC2)
# ------------------------------------------------------------------
resource "aws_iam_instance_profile" "jenkins_controller_profile" {
  name = "jenkins-controller-profile-${var.environment}"
  role = aws_iam_role.jenkins_controller_role.name
}