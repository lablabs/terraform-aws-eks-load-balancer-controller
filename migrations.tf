# Installation methods
moved {
  from = helm_release.this
  to   = module.addon.helm_release.this
}

moved {
  from = helm_release.argo_application
  to   = module.addon.helm_release.argo_application
}

moved {
  from = kubernetes_manifest.this
  to   = module.addon.kubernetes_manifest.this
}

# IRSA
moved {
  from = aws_iam_policy.this
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_policy.this
}

moved {
  from = aws_iam_role.this
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_role.this
}

moved {
  from = aws_iam_role_policy_attachment.this
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_role_policy_attachment.this
}

# Pod identity
moved {
  from = aws_eks_pod_identity_association.this
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_eks_pod_identity_association.pod_identity
}

moved {
  from = aws_iam_policy.eks_pod_identity
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_policy.pod_identity
}

moved {
  from = aws_iam_role.eks_pod_identity
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_role.pod_identity
}

moved {
  from = aws_iam_role_policy_attachment.eks_pod_identity
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_role_policy_attachment.pod_identity
}
