# IMPORTANT: This file is synced with the "terraform-aws-eks-universal-addon" module. Any changes to this file might be overwritten upon the next release of that module.

variable "rbac_create" {
  type        = bool
  default     = null
  description = "Whether to create and use RBAC resources. Defaults to `true`."
}

variable "service_account_create" {
  type        = bool
  default     = null
  description = "Whether to create Service Account. Defaults to `true`."
}

variable "service_account_name" {
  type        = string
  default     = null
  description = "The Kubernetes Service Account name. Defaults to the addon name. Defaults to `\"\"`."
}

variable "service_account_namespace" {
  type        = string
  default     = null
  description = "The Kubernetes Service Account namespace. Defaults to the addon namespace. Defaults to `\"\"`."
}
