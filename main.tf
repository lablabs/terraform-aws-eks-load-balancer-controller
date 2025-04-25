/**
 * # AWS EKS Load Balancer Controller Terraform module
 *
 * A Terraform module to deploy the AWS Load Balancer Controller on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/pre-commit.yml)
 */
locals {
  addon = {
    # TODO: Is the name correct?
    name = "load-balancer-controller"

    helm_chart_name    = "aws-load-balancer-controller"
    helm_chart_version = "1.11.0"
    helm_repo_url      = "https://aws.github.io/eks-charts"
  }

  addon_irsa = {
    (local.addon.name) = {}
  }

  addon_values = yamlencode({
    serviceAccount = {
      create = var.service_account_create != null ? var.service_account_create : true
      name   = var.service_account_name != null ? var.service_account_name : local.addon.name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }
  })
}
