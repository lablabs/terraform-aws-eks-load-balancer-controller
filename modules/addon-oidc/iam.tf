locals {
  oidc_provider_create     = var.enabled && var.oidc_provider_create
  oidc_role_create         = var.enabled && var.oidc_role_create
  oidc_role_name           = trim("${var.oidc_role_name_prefix}-${var.oidc_role_name}", "-")
  oidc_policy_enabled      = var.oidc_policy_enabled && length(var.oidc_policy) > 0
  oidc_assume_role_enabled = var.oidc_assume_role_enabled && length(var.oidc_assume_role_arns) > 0
}

resource "aws_iam_openid_connect_provider" "this" {
  count = local.oidc_provider_create ? 1 : 0

  url             = "https://${var.oidc_openid_provider_url}"
  client_id_list  = var.oidc_openid_client_ids
  thumbprint_list = var.oidc_openid_thumbprints

  tags = var.oidc_tags
}

data "aws_iam_policy_document" "this_assume" {
  count = local.oidc_role_create && local.oidc_assume_role_enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = var.oidc_assume_role_arns
  }
}

resource "aws_iam_policy" "this" {
  count = local.oidc_role_create && (local.oidc_policy_enabled || local.oidc_assume_role_enabled) ? 1 : 0

  name   = local.oidc_role_name # tflint-ignore: aws_iam_policy_invalid_name
  path   = "/"
  policy = var.oidc_assume_role_enabled ? data.aws_iam_policy_document.this_assume[0].json : var.oidc_policy

  tags = var.oidc_tags
}

data "aws_iam_policy_document" "this_oidc" {
  count = local.oidc_role_create ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [coalesce(var.oidc_custom_provider_arn, one(aws_iam_openid_connect_provider.this[*].arn))]
    }

    condition {
      test     = var.oidc_assume_role_policy_condition_test
      variable = var.oidc_assume_role_policy_condition_variable
      values   = var.oidc_assume_role_policy_condition_values
    }
  }
}

resource "aws_iam_role" "this" {
  count = local.oidc_role_create ? 1 : 0

  name                 = local.oidc_role_name # tflint-ignore: aws_iam_role_invalid_name
  assume_role_policy   = data.aws_iam_policy_document.this_oidc[0].json
  permissions_boundary = var.oidc_permissions_boundary

  tags = var.oidc_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.oidc_role_create && (local.oidc_policy_enabled || local.oidc_assume_role_enabled) ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "this_additional" {
  for_each = local.oidc_role_create ? var.oidc_additional_policies : {}

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}
