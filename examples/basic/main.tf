module "addon_installation_disabled" {
  source = "../../"

  enabled = false

  cluster_name                     = module.eks_cluster.eks_cluster_id
  cluster_identity_oidc_issuer     = module.eks_cluster.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn
}

module "addon_installation_helm" {
  source = "../../"

  enabled           = true
  argo_enabled      = false
  argo_helm_enabled = false

  cluster_name                     = module.eks_cluster.eks_cluster_id
  cluster_identity_oidc_issuer     = module.eks_cluster.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn

  values = yamlencode({
    # insert sample values here
    clusterName = module.eks_cluster.eks_cluster_id
  })
}

module "addon_installation_helm_pod_identity" {
  source = "../../"

  enabled           = true
  argo_enabled      = false
  argo_helm_enabled = false

  cluster_name = module.eks_cluster.eks_cluster_id

  # Disable IRSA
  irsa_role_create = false

  # Enable pod identity
  pod_identity_role_create = true

  values = yamlencode({
    # insert sample values here
    clusterName = module.eks_cluster.eks_cluster_id
  })
}

# Please, see README.md and Argo Kubernetes deployment method for implications of using Kubernetes installation method
module "addon_installation_argo_kubernetes" {
  source = "../../"

  enabled           = true
  argo_enabled      = true
  argo_helm_enabled = false

  cluster_name                     = module.eks_cluster.eks_cluster_id
  cluster_identity_oidc_issuer     = module.eks_cluster.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn

  values = yamlencode({
    # insert sample values here
    clusterName = module.eks_cluster.eks_cluster_id
  })

  argo_sync_policy = {
    automated   = {}
    syncOptions = ["CreateNamespace=true"]
  }
}

module "addon_installation_argo_helm" {
  source = "../../"

  enabled           = true
  argo_enabled      = true
  argo_helm_enabled = true

  cluster_name                     = module.eks_cluster.eks_cluster_id
  cluster_identity_oidc_issuer     = module.eks_cluster.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn

  values = yamlencode({
    # insert sample values here
    clusterName = module.eks_cluster.eks_cluster_id
  })

  argo_sync_policy = {
    automated   = {}
    syncOptions = ["CreateNamespace=true"]
  }
}
