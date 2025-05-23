/**
 * # AWS EKS Load Balancer Controller Terraform module
 *
 * A Terraform module to deploy the [AWS Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/pre-commit.yml)
 */
locals {
  addon = {
    name = "aws-load-balancer-controller"

    helm_chart_version = "1.12.0"
    helm_repo_url      = "https://aws.github.io/eks-charts"
  }

  addon_irsa = {
    (local.addon.name) = {
      irsa_policy_enabled         = local.irsa_policy_enabled
      irsa_policy                 = var.irsa_policy != null ? var.irsa_policy : try(data.aws_iam_policy_document.this[0].json, "")
      pod_identity_policy_enabled = local.pod_identity_policy_enabled
      pod_identity_policy         = var.pod_identity_policy != null ? var.pod_identity_policy : try(data.aws_iam_policy_document.this[0].json, "")
    }
  }

  addon_values = yamlencode({
    clusterName = var.cluster_name
    serviceAccount = {
      create = var.service_account_create != null ? var.service_account_create : true
      name   = var.service_account_name != null ? var.service_account_name : local.addon.name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }
    podMutatorWebhookConfig = {
      failurePolicy = "Fail"
    }
  })

  addon_depends_on = []
}
