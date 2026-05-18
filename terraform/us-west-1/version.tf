terraform {
  backend "s3" {
    bucket         = "new-hello-app-terraform-state"
    key            = "hello-app/us-west-1/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
