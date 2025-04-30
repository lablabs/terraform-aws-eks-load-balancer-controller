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

variable "pod_identity_role_create" {
  type        = bool
  default     = false
  description = "Whether to create pod identity role."
}

variable "pod_identity_role_name_prefix" {
  type        = string
  default     = "lb-controller-pod-identity"
  description = "Pod identity role name prefix. Either `pod_identity_role_name_prefix` or `pod_identity_role_name` must be set."
}

variable "pod_identity_role_name" {
  type        = string
  default     = null
  description = "Pod identity role name. The value is prefixed by `pod_identity_role_name_prefix`. Either `pod_identity_role_name` or `pod_identity_role_name_prefix` must be set. Defaults to `\"\"`."
}

variable "pod_identity_policy" {
  type        = string
  default     = null
  description = "AWS IAM policy JSON document to be attached to the pod identity role. Applied only if `pod_identity_policy_enabled` is `true`. Default policy is defined in iam.tf."
}

variable "pod_identity_policy_enabled" {
  type        = bool
  default     = true
  description = "Whether to create IAM policy specified by `pod_identity_policy`."
}

variable "pod_identity_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the pod identity role."
}

variable "pod_identity_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to pod identity role. Where key is arbitrary id and value is policy ARN."
}

variable "pod_identity_tags" {
  type        = map(string)
  default     = {}
  description = "The Pod identity resources tags."
}
