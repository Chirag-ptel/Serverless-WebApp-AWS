variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "name" {
  type        = string
  description = "name of the resource"
  default     = "dynamodb-table-1"
}