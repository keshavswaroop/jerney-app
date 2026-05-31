terraform {
  backend "s3" {
    bucket         = "swaroop-terraform-state-2026"
    key            = "jerney/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}