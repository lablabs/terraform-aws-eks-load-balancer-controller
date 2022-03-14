locals {
  argo_application_values = {
    "project" : var.argo_project
    "source" : {
      "repoURL" : var.helm_repo_url
      "chart" : var.helm_chart_name
      "targetRevision" : var.helm_chart_version
      "helm" : {
        "releaseName" : var.helm_release_name
        "parameters" : [for k, v in var.settings : tomap({ "forceString" : true, "name" : k, "value" : v })]
        "values" : var.enabled ? data.utils_deep_merge_yaml.values[0].output : ""
      }
    }
    "destination" : {
      "server" : var.argo_destionation_server
      "namespace" : var.k8s_namespace
    }
    "syncPolicy" : var.argo_sync_policy
    "info" : var.argo_info
  }
}

data "utils_deep_merge_yaml" "argo_helm_values" {
  count = var.enabled && var.argo_enabled && var.argo_helm_enabled ? 1 : 0
  input = compact([
    yamlencode({
      "spec" : local.argo_application_values
    }),
    yamlencode({
      "spec" : var.argo_spec
    })
  ])
}

resource "helm_release" "argo_application" {
  count = var.enabled && var.argo_enabled && var.argo_helm_enabled ? 1 : 0

  chart     = "${path.module}/helm/argocd-application"
  name      = var.helm_release_name
  namespace = var.argo_namespace

  values = [
    data.utils_deep_merge_yaml.argo_helm_values[0].output,
    var.argo_helm_values
  ]
}

data "utils_deep_merge_yaml" "argo_spec" {
  count = var.enabled && var.argo_enabled && !var.argo_helm_enabled ? 1 : 0
  input = compact([
    yamlencode(local.argo_application_values),
    yamlencode(var.argo_spec)
  ])
}

resource "kubernetes_manifest" "this" {
  count = var.enabled && var.argo_enabled && !var.argo_helm_enabled ? 1 : 0
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = var.helm_release_name
      "namespace" = var.argo_namespace
    }
    "spec" = yamldecode(data.utils_deep_merge_yaml.argo_spec[0].output)
  }
}
