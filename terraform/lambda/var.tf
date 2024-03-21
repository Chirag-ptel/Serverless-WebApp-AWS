variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "name" {
  type        = string
  description = "name of the lambda function"
}

variable "func_name" {
  type        = string
  description = "name of the lambda function"
}

variable "endpoint_path" {
  type        = string
  description = ""
  default     = "{proxy+}"
}
