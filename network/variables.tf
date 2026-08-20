variable "create_vpc" {
  description = "(Optional) Boolean value to specify if u want to create vpc"
  type        = bool
  default     = true
}

variable "create_public_subnets" {
  description = "(Optional) Boolean value to specify if u want to create public subnets in vpc"
  type        = bool
  default     = true
}

variable "create_private_subnets" {
  description = "(Optional) Boolean value to specify if u want to create private subnets in vpc"
  type        = bool
  default     = true
}

variable "create_igw" {
  description = "(Optional) Boolean value to specify if u want to create igw in vpc"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "(Optional) Boolean value to specify if u want to create nat for each pub subnet"
  type        = bool
  default     = false
}

variable "region" {
  description = "(Required) aws region where to create vpc"
  type        = string
}

variable "cidr" {
  description = "(Optional) IPv4 Range of addresses for your VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "(Optional) A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "name" {
  description = "(Required) Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "azs" {
  description = "(Optional) A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "(Optional Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `false`"
  type        = bool
  default     = false
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "name_prefix" {
  description = "(Required) passed name prefix for my project"
  type        = string
}
