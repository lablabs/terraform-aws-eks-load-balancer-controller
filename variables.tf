# IMPORTANT: Add addon specific variables here
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "aws_partition" {
  type        = string
  default     = "aws"
  description = "AWS partition in which the resources are located. Available values are `aws`, `aws-cn`, `aws-us-gov`"
}

variable "eks_pod_identity_role_create" {
  type        = bool
  default     = false
  description = "Determines whether to enable support for the EKS pod identity"
}

variable "eks_pod_identity_role_name_prefix" {
  type        = string
  default     = "lb-controller-pod-identity"
  description = "The EKS pod identity role name prefix for LB controller"
}

variable "eks_pod_identity_policy_enabled" {
  type        = bool
  default     = true
  description = "Whether to create opinionated policy for LB controller, see https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/v2.12.0/docs/install/iam_policy.json"
}

variable "eks_pod_identity_tags" {
  type        = map(string)
  default     = {}
  description = "The EKS Pod identity resources tags"
}
