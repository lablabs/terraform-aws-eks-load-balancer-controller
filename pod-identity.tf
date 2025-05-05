locals {
  pod_identity_service_account_create    = var.service_account_create != null ? var.service_account_create : true
  pod_identity_service_account_name      = var.service_account_name != null ? var.service_account_name : try(local.addon.name)
  pod_identity_service_account_namespace = var.service_account_namespace != null ? var.service_account_namespace : local.addon_namespace
  rbac_create                            = var.rbac_create != null ? var.rbac_create : true
  pod_identity_role_create               = var.enabled && local.rbac_create && local.pod_identity_service_account_create && var.pod_identity_role_create
  pod_identity_role_name                 = var.pod_identity_role_name != null ? var.pod_identity_role_name : trim("${var.pod_identity_role_name_prefix}-${local.addon.name}", "-")
  pod_identity_policy                    = var.pod_identity_policy != null ? var.pod_identity_policy : data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "pod_identity" {
  count = local.pod_identity_role_create ? 1 : 0

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
  count       = local.pod_identity_role_create && (var.pod_identity_policy_enabled) ? 1 : 0
  name        = local.pod_identity_role_name # tflint-ignore: aws_iam_policy_invalid_name
  description = "Policy for aws-load-balancer-controller service"

  policy = local.pod_identity_policy
  tags   = var.pod_identity_tags
}

resource "aws_iam_role" "pod_identity" {
  count = local.pod_identity_role_create ? 1 : 0

  name                 = local.pod_identity_role_name # tflint-ignore: aws_iam_role_invalid_name
  assume_role_policy   = data.aws_iam_policy_document.pod_identity[0].json
  permissions_boundary = var.pod_identity_permissions_boundary

  tags = var.pod_identity_tags
}

resource "aws_iam_role_policy_attachment" "pod_identity" {
  count = local.pod_identity_role_create && (var.pod_identity_policy_enabled) ? 1 : 0

  role       = aws_iam_role.pod_identity[0].name
  policy_arn = aws_iam_policy.pod_identity[0].arn
}

resource "aws_iam_role_policy_attachment" "pod_identity_additional" {
  for_each = local.pod_identity_role_create ? var.pod_identity_additional_policies : {}

  role       = aws_iam_role.pod_identity[0].name
  policy_arn = each.value
}

resource "aws_eks_pod_identity_association" "pod_identity" {
  count = local.pod_identity_role_create ? 1 : 0

  cluster_name    = var.cluster_name
  namespace       = local.pod_identity_service_account_namespace
  service_account = local.pod_identity_service_account_name
  role_arn        = aws_iam_role.pod_identity[0].arn
  tags            = var.pod_identity_tags
}
