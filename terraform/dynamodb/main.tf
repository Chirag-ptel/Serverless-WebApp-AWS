resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "${var.name}-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "RideId"
#   range_key      = "GameTitle"
  table_class    = "STANDARD"

  attribute {
    name = "RideId"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  point_in_time_recovery {
    enabled = false
  }

  server_side_encryption {
    enabled     = false
    # kms_key_arn = aws_kms_key.mykey.arn
  }


#   global_secondary_index {
#     name               = "GameTitleIndex"
#     hash_key           = "GameTitle"
#     range_key          = "TopScore"
#     write_capacity     = 10
#     read_capacity      = 10
#     projection_type    = "INCLUDE"
#     non_key_attributes = ["UserId"]
#   }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}