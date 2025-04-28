# IMPORTANT: This file is synced with the "terraform-aws-eks-universal-addon" module. Any changes to this file might be overwritten upon the next release of that module.
module "addon-pod-identity" {
  for_each = local.addon_pod_identity

  source = "git::https://github.com/lablabs/terraform-aws-eks-universal-addon.git//modules/addon-pod-identity?ref=933f64d"

  enabled = var.enabled

  cluster_name = var.cluster_name != null ? var.cluster_name : try(each.value.cluster_name, null)
  # TODO: Do I need this?
  rbac_create = var.rbac_create != null ? var.rbac_create : try(each.value.rbac_create, true)
  # TODO: Do I need this?
  service_account_create    = var.service_account_create != null ? var.service_account_create : try(each.value.service_account_create, true)
  service_account_name      = var.service_account_name != null ? var.service_account_name : try(each.value.service_account_name, each.key)
  service_account_namespace = var.service_account_namespace != null ? var.service_account_namespace : try(each.value.service_account_namespace, local.addon_namespace)

  pod_identity_role_create      = var.pod_identity_role_create != null ? var.pod_identity_role_create : try(each.value.pod_identity_role_create, true)
  pod_identity_role_name_prefix = var.pod_identity_role_name_prefix != null ? var.pod_identity_role_name_prefix : try(each.value.pod_identity_role_name_prefix, "${each.key}-epi")
  pod_identity_role_name        = var.pod_identity_role_name != null ? var.pod_identity_role_name : try(each.value.pod_identity_role_name, local.addon_name)

  pod_identity_policy_enabled       = var.pod_identity_policy_enabled != null ? var.pod_identity_policy_enabled : try(each.value.pod_identity_policy_enabled, false)
  pod_identity_policy               = var.pod_identity_policy != null ? var.pod_identity_policy : try(each.value.pod_identity_policy, "")
  pod_identity_assume_role_enabled  = var.pod_identity_assume_role_enabled != null ? var.pod_identity_assume_role_enabled : try(each.value.pod_identity_assume_role_enabled, false)
  pod_identity_assume_role_arns     = var.pod_identity_assume_role_arns != null ? var.pod_identity_assume_role_arns : try(each.value.pod_identity_assume_role_arns, [])
  pod_identity_permissions_boundary = var.pod_identity_permissions_boundary != null ? var.pod_identity_permissions_boundary : try(each.value.pod_identity_permissions_boundary, null)
  pod_identity_additional_policies  = var.pod_identity_additional_policies != null ? var.pod_identity_additional_policies : try(each.value.pod_identity_additional_policies, tomap({}))

  pod_identity_tags = var.pod_identity_tags != null ? var.pod_identity_tags : try(each.value.pod_identity_tags, tomap({}))
}

output "addon_pod_identity" {
  description = "The addon pod identity module outputs"
  value       = module.addon-pod-identity
}
