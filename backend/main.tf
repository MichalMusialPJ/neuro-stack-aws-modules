locals {
  tags = merge(var.tags, { ManagedBy = "terraform" })
}

resource "aws_s3_bucket" "this" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.bucket_name

  versioning {
    enabled = false
  }

  tags = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.create_bucket_sse && var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "this" {
  count = var.create_lock_table ? 1 : 0

  name         = var.dynamodb_table_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}
