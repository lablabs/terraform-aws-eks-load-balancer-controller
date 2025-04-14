variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster (required)."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a Service Account (required)."
}

variable "rbac_create" {
  type        = bool
  default     = true
  description = "Whether to create and use RBAC resources."
}

variable "service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create Service Account."
}

variable "service_account_name" {
  type        = string
  default     = ""
  description = "The Kubernetes Service Account name. Defaults to the addon name."
}

variable "service_account_namespace" {
  type        = string
  default     = ""
  description = "The Kubernetes Service Account namespace. Defaults to the addon namespace."
}

variable "irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create IRSA role and annotate Service Account."
}

variable "irsa_role_name_prefix" {
  type        = string
  default     = ""
  description = "IRSA role name prefix. Either `irsa_role_name_prefix` or `irsa_role_name` must be set."
}

variable "irsa_role_name" {
  type        = string
  default     = ""
  description = "IRSA role name. The value is prefixed by `irsa_role_name_prefix`. Either `irsa_role_name` or `irsa_role_name_prefix` must be set."
}

variable "irsa_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `irsa_policy`. Mutually exclusive with `irsa_assume_role_enabled`."
}

variable "irsa_policy" {
  type        = string
  default     = ""
  description = "AWS IAM policy JSON document to be attached to the IRSA role. Applied only if `irsa_policy_enabled` is `true`."
}

variable "irsa_assume_role_enabled" {
  type        = bool
  default     = false
  description = "Whether IRSA is allowed to assume role defined by `irsa_assume_role_arn`. Mutually exclusive with `irsa_policy_enabled`."
}

variable "irsa_assume_role_arns" {
  type        = list(string)
  default     = []
  description = "List of ARNs assumable by the IRSA role. Applied only if `irsa_assume_role_enabled` is `true`."
}

variable "irsa_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the IRSA role."
}

variable "irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to IRSA role. Where key is arbitrary id and value is policy ARN."
}

variable "irsa_tags" {
  type        = map(string)
  default     = {}
  description = "IRSA resources tags."
}

variable "irsa_assume_role_policy_condition_test" {
  type        = string
  default     = "StringEquals"
  description = "Specifies the condition test to use for the assume role trust policy."
}

variable "irsa_assume_role_policy_condition_values" {
  type        = list(string)
  default     = []
  description = "Specifies the values for the assume role trust policy condition. Each entry in this list must follow the required format `system:serviceaccount:$service_account_namespace:$service_account_name`. If this variable is left as the default, `local.irsa_assume_role_policy_condition_values_default` is used instead, which is a list containing a single value. Note that if this list is defined, the `service_account_name` and `service_account_namespace` variables are ignored."
}
