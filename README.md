# terraform-aws-eks

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

### Providers

| Name | Version |
|------|---------|
| aws | n/a |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cluster\_name | Name of the EKS cluster | `string` | n/a | yes |
| desired\_size | Autoscaling Desired node capacity | `string` | `2` | no |
| eks\_logging | A list of the desired control plane logging to enable | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| kubernetes\_version | The EKS Kubernetes version | `string` | n/a | yes |
| max\_size | Autoscaling maximum node capacity | `string` | `5` | no |
| min\_size | Autoscaling Minimum node capacity | `string` | `1` | no |
| node\_instance\_type | Worker Node EC2 instance type | `string` | n/a | yes |
| node\_pools | Addons node pools | <pre>map(object({<br>    desired_size       = number<br>    node_instance_type = string<br>    max_size           = number<br>    min_size           = number<br>  }))</pre> | `{}` | no |
| private\_subnet\_tags | Tags for private subnets | `map(string)` | <pre>{<br>  "made-by": "terraform"<br>}</pre> | no |
| public\_subnet\_tags | Tags for public subnets | `map(string)` | <pre>{<br>  "made-by": "terraform"<br>}</pre> | no |
| tags | Tags associated to the resources | `map(string)` | <pre>{<br>  "made-by": "terraform"<br>}</pre> | no |
| vpc\_id | ID of the VPC | `string` | n/a | yes |

### Outputs

No output.
