provider "aws" {
  region = "us-east-2"
}

# terraform {
#   backend "s3" {
#     bucket = "lekan-tf-state"
#     key = "global/s3/terraform.tfstate"
#     region = "us-east-2"

#     dynamodb_table = "tf-up-run-state-locks"
#     encrypt = true
#   }
# }

resource "aws_s3_bucket" "tf_state" {
  bucket = "lekan-tf-state"

  # lifecycle {
  #   prevent_destroy = true
  # }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "tf-up-run-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.tf_state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "The name of the Dynamo table"
}

