variable "region" {
#   type    = string
#   default = "ap-south-1"
}
variable "access_token" {
#   type    = string
#   default = "ap-south-1"

}

variable "token" {
  type        = string
  description = "github token to connect github repo"
}

variable "repository" {
  type        = string
  description = "github repo url"
  default     = "https://github.com/Chirag-ptel/Serverless-WebApp-AWS"
}

variable "app_name" {
  type        = string
  description = "AWS Amplify App Name"
  default     = "my-amplify"
}

variable "branch_name" {
  type        = string
  description = "AWS Amplify App Repo Branch Name"
  default     = "master"
}