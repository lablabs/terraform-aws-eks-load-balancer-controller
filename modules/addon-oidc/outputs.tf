output "oidc_provider_enabled" {
  description = "Whether OIDC provider is enabled"
  value       = local.oidc_provider_create
}

output "oidc_role_enabled" {
  description = "Whether OIDC role is enabled"
  value       = local.oidc_role_create
}

output "iam_role_attributes" {
  description = "IAM role attributes"
  value       = try(aws_iam_role.this[0], {})
}
