output "bucket_name" {
  description = "Name of the bucket"
  value       = try(aws_s3_bucket.this[0].bucket, null)
}

output "bucket_id" {
  description = "ID of the bucket"
  value       = try(aws_s3_bucket.this[0].id, null)
}

output "bucket_arn" {
  description = "ARN of bucket"
  value       = try(aws_s3_bucket.this[0].arn, null)
}

output "dynamodb_table_name" {
  description = "Name of dynamodb table"
  value       = try(aws_dynamodb_table.this[0].name, null)
}

output "dynamodb_table_id" {
  description = "ID of dynamodb table"
  value       = try(aws_dynamodb_table.this[0].id, null)
}

output "dynamodb_table_arn" {
  description = "ARN of dynamodb table"
  value       = try(aws_dynamodb_table.this[0].arn, null)
}
