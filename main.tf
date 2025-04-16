/**
 * # AWS EKS Load Balancer Controller Terraform module
 *
 * A Terraform module to deploy the AWS Load Balancer Controller on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/pre-commit.yml)
 */
locals {
  # FIXME config: add addon configuration here
  addon = {
    # TODO: Is the name correct?
    name = "load-balancer-controller"

    helm_chart_name    = "aws-load-balancer-controller"
    helm_chart_version = "1.11.0"
    helm_repo_url      = "https://aws.github.io/eks-charts"
  }

  # FIXME config: add addon IRSA configuration here or remove if not needed
  addon_irsa = {
    (local.addon.name) = {
      # FIXME config: add default IRSA overrides here or leave empty if not needed, but make sure to keep at least one key
    }
  }

  addon_values = yamlencode({
    # FIXME config: add default values here
  })
}
