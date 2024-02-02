# Basic example

The code in this example shows how to use the module with basic configuration and minimal set of other resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.11.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | cloudposse/eks-cluster/aws | 0.45.0 |
| <a name="module_eks_node_group"></a> [eks\_node\_group](#module\_eks\_node\_group) | cloudposse/eks-node-group/aws | 0.28.0 |
| <a name="module_lb_controller_argo_helm"></a> [lb\_controller\_argo\_helm](#module\_lb\_controller\_argo\_helm) | ../../ | n/a |
| <a name="module_lb_controller_argo_kubernetes"></a> [lb\_controller\_argo\_kubernetes](#module\_lb\_controller\_argo\_kubernetes) | ../../ | n/a |
| <a name="module_lb_controller_helm"></a> [lb\_controller\_helm](#module\_lb\_controller\_helm) | ../../ | n/a |
| <a name="module_lbc_disabled"></a> [lbc\_disabled](#module\_lbc\_disabled) | ../../ | n/a |
| <a name="module_lbc_without_irsa_policy"></a> [lbc\_without\_irsa\_policy](#module\_lbc\_without\_irsa\_policy) | ../../ | n/a |
| <a name="module_lbc_without_irsa_role"></a> [lbc\_without\_irsa\_role](#module\_lbc\_without\_irsa\_role) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.5.1 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
