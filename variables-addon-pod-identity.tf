# IMPORTANT: This file is synced with the "terraform-aws-eks-universal-addon" module. Any changes to this file might be overwritten upon the next release of that module.

variable "cluster_name" {
  type        = string
  default     = null
  description = "The name of the cluster"
}

variable "pod_identity_role_create" {
  type        = bool
  default     = null
  description = "Whether to create pod identity role. Defaults to `true`."
}

variable "pod_identity_role_name_prefix" {
  type        = string
  default     = null
  description = "Pod identity role name prefix. Either `pod_identity_role_name_prefix` or `pod_identity_role_name` must be set. Defaults to `\"\"`."
}

variable "pod_identity_role_name" {
  type        = string
  default     = null
  description = "Pod identity role name. The value is prefixed by `pod_identity_role_name_prefix`. Either `pod_identity_role_name` or `pod_identity_role_name_prefix` must be set. Defaults to `\"\"`."
}

variable "pod_identity_policy_enabled" {
  type        = bool
  default     = null
  description = "Whether to create IAM policy specified by `pod_identity_policy`. Mutually exclusive with `pod_identity_assume_role_enabled`. Defaults to `false`."
}

variable "pod_identity_policy" {
  type        = string
  default     = null
  description = "AWS IAM policy JSON document to be attached to the pod identity role. Applied only if `pod_identity_policy_enabled` is `true`. Defaults to `\"\"`."
}

variable "pod_identity_assume_role_enabled" {
  type        = bool
  default     = null
  description = "Whether pod identity is allowed to assume role defined by `pod_identity_assume_role_arn`. Mutually exclusive with `pod_identity_policy_enabled`. Defaults to `false`."
}

variable "pod_identity_assume_role_arns" {
  type        = list(string)
  default     = null
  description = "List of ARNs assumable by the pod identity role. Applied only if `pod_identity_assume_role_enabled` is `true`. Defaults to `[]`."
}

variable "pod_identity_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the pod identity role. Defaults to `null`."
}

variable "pod_identity_additional_policies" {
  type        = map(string)
  default     = null
  description = "Map of the additional policies to be attached to pod identity role. Where key is arbitrary id and value is policy ARN. Defaults to `{}`."
}

variable "pod_identity_tags" {
  type        = map(string)
  default     = null
  description = "Pod identity resources tags. Defaults to `{}`."
}
