locals {
  service_account_create    = var.service_account_create != null ? var.service_account_create : true
  service_account_name      = var.service_account_name != null ? var.service_account_name : try(local.addon.name)
  service_account_namespace = var.service_account_namespace != null ? var.service_account_namespace : local.addon_namespace
  #pod_identity_role_create     = var.enabled && local.service_account_create && var.pod_identity_role_create
  #helm_release_name            = local.addon_name

  rbac_create = var.rbac_create != null ? var.rbac_create : true

  pod_identity_role_create         = var.enabled && var.rbac_create && var.service_account_create && var.pod_identity_role_create
  pod_identity_role_name           = trim("${var.pod_identity_role_name_prefix}-${var.pod_identity_role_name}", "-")
  pod_identity_policy_enabled      = var.pod_identity_policy_enabled && length(var.pod_identity_policy) > 0
  pod_identity_assume_role_enabled = var.pod_identity_assume_role_enabled

}

data "aws_iam_policy_document" "pod_identity_assume" {
  count = local.pod_identity_role_create && local.pod_identity_assume_role_enabled ? 1 : 0

  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_policy" "pod_identity" {
  count = local.pod_identity_role_create && (local.pod_identity_policy_enabled || local.pod_identity_assume_role_enabled) ? 1 : 0
  #name        = "${var.pod_identity_role_name_prefix}-${local.helm_release_name}"
  name        = local.pod_identity_role_name # tflint-ignore: aws_iam_policy_invalid_name
  description = "Policy for aws-load-balancer-controller service"

  #policy = data.aws_iam_policy_document.this[0].json
  #policy = var.pod_identity_assume_role_enabled ? data.aws_iam_policy_document.this_assume[0].json : var.pod_identity_policy
  policy = var.pod_identity_assume_role_enabled ? data.aws_iam_policy_document.this[0].json : var.pod_identity_policy
  tags   = var.pod_identity_tags
}

resource "aws_iam_role" "pod_identity" {
  count = local.pod_identity_role_create ? 1 : 0

  #name               = "${var.pod_identity_role_name_prefix}-${local.helm_release_name}"
  name = local.pod_identity_role_name # tflint-ignore: aws_iam_role_invalid_name
  #assume_role_policy = data.aws_iam_policy_document.pod_identity_assume[0].json
  #assume_role_policy   = data.aws_iam_policy_document.this_pod_identity[0].json
  assume_role_policy   = data.aws_iam_policy_document.pod_identity_assume[0].json
  permissions_boundary = var.pod_identity_permissions_boundary

  tags = var.pod_identity_tags
}

resource "aws_iam_role_policy_attachment" "pod_identity" {
  #count = local.pod_identity_role_create ? 1 : 0
  count = local.pod_identity_role_create && (local.pod_identity_policy_enabled || local.pod_identity_assume_role_enabled) ? 1 : 0

  role       = aws_iam_role.pod_identity[0].name
  policy_arn = aws_iam_policy.pod_identity[0].arn
}

resource "aws_iam_role_policy_attachment" "pod_identity_additional" {
  for_each = local.pod_identity_role_create ? var.pod_identity_additional_policies : {}

  role       = aws_iam_role.pod_identity[0].name
  policy_arn = each.value
}





resource "aws_eks_pod_identity_association" "this" {
  count = local.pod_identity_role_create ? 1 : 0

  cluster_name    = var.cluster_name
  namespace       = local.service_account_namespace
  service_account = local.service_account_name
  role_arn        = aws_iam_role.pod_identity[0].arn
}
