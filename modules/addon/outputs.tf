output "helm_release_metadata" {
  description = "Helm release attributes"
  value       = try(helm_release.this[0].metadata, {})
}

output "helm_release_application_metadata" {
  description = "ArgoCD Application Helm release attributes"
  value       = try(helm_release.argo_application[0].metadata, {})
}

output "kubernetes_application_attributes" {
  description = "ArgoCD Kubernetes manifest attributes"
  value       = try(kubernetes_manifest.this[0], {})
}
