# IMPORTANT: Add addon specific variables here
variable "aws_partition" {
  type        = string
  default     = "aws"
  description = "AWS partition in which the resources are located. Available values are `aws`, `aws-cn`, `aws-us-gov`"
}
