terraform {
  backend "s3" {
    bucket  = "lab-cicd-terraform-state"
    key     = "terraform/dev/terraform.tfstate" 
    region  = "ap-southeast-1"
    encrypt = true
  }
}
