# terraform-aws-eks

![Tfsec](https://github.com/nlamirault/terraform-aws-eks/workflows/Tfsec/badge.svg)
[![GitHub release](https://img.shields.io/github/release/nlamirault/terraform-aws-eks.svg)](https://github.com/nlamirault/terraform-aws-eks/releases/latest)

Terraform module which configure a Kubernetes cluster (EKS) on Amazon AWS.

## Versions

Use Terraform `0.13` and Terraform Azure Provider `2.3+`.

## Usage

```hcl
module "eks" {
  source  = "nlamirault/eks/aws"
  version = "X.Y.Z"

  cluster_name = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id              = var.vpc_id
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags

  desired_size = var.desired_size
  min_size     = var.min_size
  max_size     = var.max_size

  eks_logging = var.eks_logging

  node_instance_type = var.node_instance_type

  tags = var.tags

  node_pools = var.node_pools
}


}
```

```hcl

vpc_id = "vpc-xxxxxxxxxxxxx"

public_subnet_tags = {
    "service" = "public-subnet"
}

private_subnet_tags = {
    "service" = "private-subnet"
}

cluster_name = "foo-staging-eks"

kubernetes_version = "1.18"

desired_size = 2
min_size = 1
max_size = 3

node_instance_type = "t3.large"

tags = {
    "project" = "foo"
    "env"     = "staging"
    "service" = "kubernetes"
    "made-by" = "terraform"
}

node_pools = {
    "ops" = {
        desired_size = 1
        min_size = 1
        max_size = 1
        node_instance_type = "t2.large"
    },
}
```

This module creates :

* a Kubernetes cluster

## Documentation

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| aws | >= 3.26.0 |
| tls | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.26.0 |
| tls | 3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| sg_cluster | terraform-aws-modules/security-group/aws | 3.17.0 |
| sg_node | terraform-aws-modules/security-group/aws | 3.17.0 |

## Resources

| Name |
|------|
| [aws_eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/resources/eks_cluster) |
| [aws_eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/resources/eks_node_group) |
| [aws_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/resources/iam_instance_profile) |
| [aws_iam_openid_connect_provider](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/resources/iam_openid_connect_provider) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/resources/iam_role) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/resources/iam_role_policy_attachment) |
| [aws_secretsmanager_secret](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/resources/secretsmanager_secret) |
| [aws_secretsmanager_secret_version](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/resources/secretsmanager_secret_version) |
| [aws_subnet_ids](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/data-sources/subnet_ids) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/3.26.0/docs/data-sources/vpc) |
| [tls_certificate](https://registry.terraform.io/providers/hashicorp/tls/3.0.0/docs/data-sources/certificate) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| capacity\_type | Type of capacity associated with the EKS Node Group. Valid values: ON\_DEMAND, SPOT | `string` | n/a | yes |
| cluster\_name | Name of the EKS cluster | `string` | n/a | yes |
| desired\_size | Autoscaling Desired node capacity | `string` | `2` | no |
| disk\_size | Disk size in GiB for worker nodes. | `number` | `20` | no |
| eks\_logging | A list of the desired control plane logging to enable | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| kubernetes\_version | The EKS Kubernetes version | `string` | n/a | yes |
| max\_size | Autoscaling maximum node capacity | `string` | `5` | no |
| min\_size | Autoscaling Minimum node capacity | `string` | `1` | no |
| namespace | The Kubernetes namespace for ebs-csi driver | `string` | `"kube-system"` | no |
| node\_instance\_type | Worker Node EC2 instance type | `string` | n/a | yes |
| node\_pools | Addons node pools | <pre>map(object({<br>    desired_size       = number<br>    node_instance_type = string<br>    max_size           = number<br>    min_size           = number<br>    capacity_type      = string<br>    disk_size          = number<br>  }))</pre> | `{}` | no |
| private\_subnet\_tags | Tags for private subnets | `map(string)` | <pre>{<br>  "made-by": "terraform"<br>}</pre> | no |
| recovery\_window\_in\_days | Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. | `number` | `30` | no |
| service\_accounts | The Kubernetes service account for ebs-csi driver | `list(string)` | <pre>[<br>  "ebs-csi-controller-sa",<br>  "ebs-snapshot-controller"<br>]</pre> | no |
| tags | Tags associated to the resources | `map(string)` | <pre>{<br>  "made-by": "terraform"<br>}</pre> | no |
| vpc\_id | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| role\_arn | Role ARN for EKS EBS CSI driver |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
