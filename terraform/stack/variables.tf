variable "subnet_ids" {
  description = "List of subnet ids."
  type        = set(string)
  default     = []
}

variable "vpc_id" {
  type        = string
  description = "VPC id."
}

variable "inbound_blocks" {
  description = "inbound blocks"
  type        = set(string)
  default     = []
}

