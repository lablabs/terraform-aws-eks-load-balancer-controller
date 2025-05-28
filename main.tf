/**
 * # AWS EKS Load Balancer Controller Terraform module
 *
 * A Terraform module to deploy the [AWS Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller) on Amazon EKS cluster.
 *
 * > [!CAUTION]
 * > **Security:** Disable TLS 1.0 and TLS 1.1
 * >
 * > We strongly recommend avoiding the use of TLS 1.0 and TLS 1.1, as they contain critical vulnerabilities.
 * > If you are configuring an Ingress or a Service of type LoadBalancer on AWS, ensure that you select a secure TLS/SSL policy by adding the appropriate annotations. This will help enforce the use of modern, secure protocols.
 * > Example annotations:
 * > - Ingress: `alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS13-1-2-2021-06`
 * > - Service: `service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy: ELBSecurityPolicy-TLS13-1-2-2021-06 `
 * >
 * > Reffer to the [AWS Annotations Guide](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/guide/ingress/annotations/) and [AWS ALB Guide](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/describe-ssl-policies.html) to choose the best option for your deployment
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-load-balancer-controller/actions/workflows/pre-commit.yml)
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
