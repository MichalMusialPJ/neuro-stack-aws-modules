variable "bucket_name" {
  type        = string
  description = "(Required) Name of the backend S3 bucket"
}

variable "dynamodb_table_name" {
  type        = string
  description = "(Optional) Name of the backend DynamoDB table"
  default     = ""
}

variable "create_lock_table" {
  type        = bool
  description = "(Optional) Set to true to create a lock table"
  default     = false
}

variable "create_bucket" {
  type        = bool
  description = "(Optional) Set to true to create a bucket"
  default     = true
}

variable "create_bucket_sse" {
  type        = bool
  description = "(Optional) Set to true to create a sse encryption for s3 bucket"
  default     = true
}

variable "tags" {
  description = "(Optional) tags for backend resources"
  type        = map(string)
  default     = {}
}
