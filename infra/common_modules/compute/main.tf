resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = "t3.medium"
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [var.private_sg_id]
  iam_instance_profile = var.instance_profile_name

  # Thêm user_data để tự động cài Jenkins
user_data = <<-EOF
              #!/bin/bash
              # Chuyển hướng toàn bộ output vào một file log để dễ debug
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              
              echo "--- Bắt đầu script user_data ---"

              # Chờ cho các tiến trình apt khác hoàn tất (cực kỳ quan trọng)
              while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
                 echo "Chờ apt lock được giải phóng..."
                 sleep 10
              done

              echo "--- Cập nhật package lists ---"
              apt-get update -y

              echo "--- Cài đặt Java (OpenJDK 17) và Curl ---"
              apt-get install -y openjdk-17-jdk curl
              
              # Kiểm tra lại Java sau khi cài đặt
              if ! command -v java &> /dev/null
              then
                  echo "!!! LỖI: Cài đặt Java thất bại. Dừng script."
                  exit 1
              fi
              echo "Java đã được cài đặt thành công."
              
              echo "--- Cài đặt Jenkins ---"
              curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
              apt-get update -y
              apt-get install -y jenkins

              echo "--- Kích hoạt và khởi động dịch vụ Jenkins ---"
              systemctl enable jenkins
              systemctl start jenkins

              echo "--- Script user_data đã hoàn tất ---"
              EOF

  tags = {
    Name = "jenkins-server"
  }
}


//Add thêm docker.io và aws-cli
