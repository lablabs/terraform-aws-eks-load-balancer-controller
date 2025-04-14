locals {
  helm_argo_application_enabled      = var.enabled == true && var.argo_enabled == true && var.argo_helm_enabled == true
  helm_argo_application_wait_enabled = local.helm_argo_application_enabled && try(length(keys(var.argo_kubernetes_manifest_wait_fields)) > 0, false)
  helm_argo_application_values = compact([
    one(data.utils_deep_merge_yaml.argo_helm_values[*].output),
    var.argo_helm_values
  ])
}

data "utils_deep_merge_yaml" "argo_helm_values" {
  count = local.helm_argo_application_enabled ? 1 : 0

  input = compact([
    yamlencode({
      apiVersion = var.argo_apiversion
    }),
    yamlencode({
      spec = local.argo_application_spec
    }),
    yamlencode({
      spec = var.argo_spec
    }),
    yamlencode(
      local.argo_application_metadata
    )
  ])
}

resource "helm_release" "argo_application" {
  count = local.helm_argo_application_enabled ? 1 : 0

  chart     = "${path.module}/helm/argocd-application"
  name      = local.argo_application_name
  namespace = var.argo_namespace

  max_history = var.helm_release_max_history

  values = local.helm_argo_application_values
}

resource "kubernetes_role" "helm_argo_application_wait" {
  count = local.helm_argo_application_wait_enabled ? 1 : 0

  metadata {
    name        = "${local.argo_application_name}-argo-application-wait"
    namespace   = var.argo_namespace
    labels      = local.argo_application_metadata.labels
    annotations = local.argo_application_metadata.annotations
  }

  rule {
    api_groups = ["argoproj.io"]
    resources  = ["applications"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "helm_argo_application_wait" {
  count = local.helm_argo_application_wait_enabled ? 1 : 0

  metadata {
    name        = "${local.argo_application_name}-argo-application-wait"
    namespace   = var.argo_namespace
    labels      = local.argo_application_metadata.labels
    annotations = local.argo_application_metadata.annotations
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = one(kubernetes_role.helm_argo_application_wait[*].metadata[0].name)
  }

  subject {
    kind      = "ServiceAccount"
    name      = one(kubernetes_service_account.helm_argo_application_wait[*].metadata[0].name)
    namespace = one(kubernetes_service_account.helm_argo_application_wait[*].metadata[0].namespace)
  }
}

resource "kubernetes_service_account" "helm_argo_application_wait" {
  count = local.helm_argo_application_wait_enabled ? 1 : 0

  metadata {
    name        = "${local.argo_application_name}-argo-application-wait"
    namespace   = var.argo_namespace
    labels      = local.argo_application_metadata.labels
    annotations = local.argo_application_metadata.annotations
  }
}

resource "kubernetes_job" "helm_argo_application_wait" {
  count = local.helm_argo_application_wait_enabled ? 1 : 0

  metadata {
    generate_name = "${local.argo_application_name}-argo-application-wait-"
    namespace     = var.argo_namespace
    labels        = local.argo_application_metadata.labels
    annotations   = local.argo_application_metadata.annotations
  }

  spec {
    template {
      metadata {
        labels      = local.argo_application_metadata.labels
        annotations = local.argo_application_metadata.annotations
      }

      spec {
        service_account_name = one(kubernetes_service_account.helm_argo_application_wait[*].metadata[0].name)

        dynamic "container" {
          for_each = var.argo_kubernetes_manifest_wait_fields

          content {
            name  = "${lower(replace(container.key, ".", "-"))}-${md5(jsonencode(local.helm_argo_application_values))}" # md5 suffix is a workaround for https://github.com/hashicorp/terraform-provider-kubernetes/issues/1325
            image = "registry.k8s.io/kubectl:v${trim(var.argo_helm_wait_kubectl_version, "v")}"
            # Waits for ArgoCD Application to be "Healthy", see https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#wait
            #   i.e. kubectl wait --for=jsonpath={.status.sync.status}=Healthy application.argoproj.io <$addon-name>
            args = [
              "wait",
              "--namespace=${var.argo_namespace}",
              "--for=jsonpath={.${container.key}}=${container.value}",
              "--timeout=${var.argo_helm_wait_timeout}",
              "--v=1", # https://kubernetes.io/docs/reference/kubectl/quick-reference/#kubectl-output-verbosity-and-debugging
              "application.argoproj.io",
              local.argo_application_name
            ]
          }
        }

        node_selector = var.argo_helm_wait_node_selector

        dynamic "toleration" {
          for_each = var.argo_helm_wait_tolerations

          content {
            key      = try(toleration.value.key, null)
            operator = try(toleration.value.operator, null)
            value    = try(toleration.value.value, null)
            effect   = try(toleration.value.effect, null)
          }
        }

        # ArgoCD Application status fields might not be available immediately after creation
        restart_policy = "OnFailure"
      }
    }

    backoff_limit = var.argo_helm_wait_backoff_limit
  }

  wait_for_completion = true

  timeouts {
    create = var.argo_helm_wait_timeout
    update = var.argo_helm_wait_timeout
  }

  depends_on = [
    helm_release.argo_application
  ]
}
