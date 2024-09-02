# Create Amazon DynamoDB tables for Terraform state locking
resource "aws_dynamodb_table" "tfstate" {
  name           = "terraform-lock-dotnet-demo"
  hash_key       = "LockID"
  read_capacity  = 4
  write_capacity = 4
  billing_mode   = "PROVISIONED"
 
  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
   enabled = true
  }

  server_side_encryption {
    enabled = true
  }
}
