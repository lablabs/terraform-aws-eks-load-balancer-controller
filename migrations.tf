# Argo
moved {
  from = helm_release.argo_application[0]
  to   = module.addon.helm_release.argo_application[0]
}

# IRSA
moved {
  from = aws_iam_policy.this[0]
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_policy.this[0]
}

moved {
  from = aws_iam_role.this[0]
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_role.this[0]
}

moved {
  from = aws_iam_role_policy_attachment.this[0]
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_role_policy_attachment.this[0]
}

# Pod identity
moved {
  from = aws_eks_pod_identity_association.this[0]
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_eks_pod_identity_association.pod_identity[0]
}

moved {
  from = aws_iam_policy.eks_pod_identity[0]
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_policy.pod_identity[0]
}

moved {
  from = aws_iam_role.eks_pod_identity[0]
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_role.pod_identity[0]
}

moved {
  from = aws_iam_role_policy_attachment.eks_pod_identity[0]
  to   = module.addon-irsa["aws-load-balancer-controller"].aws_iam_role_policy_attachment.pod_identity[0]
}
