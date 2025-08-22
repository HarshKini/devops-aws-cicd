variable "project_name" { default = "devops-aws-cicd" }
# Change bucket_name to be globally unique (e.g., add a short suffix)
variable "bucket_name" { default = "hk-devops-aws-cicd-site-glob" }

variable "tags" {
  type = map(string)
  default = {
    Project = "DevOps-AWS-CI-CD"
    Owner   = "Harsh-Kini"
    Env     = "prod"
  }
}
