# Copyright (C) 2020-2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "aws_eks_cluster" "eks" {
  name = var.cluster_name

  version = var.kubernetes_version

  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids = [
      module.sg_cluster.this_security_group_id,
      module.sg_node.this_security_group_id,
    ]
    subnet_ids = data.aws_subnet_ids.private.ids
  }

  dynamic "encryption_config" {
    for_each = var.enable_kms ? [1] : []
    content {
      resources = [ "secrets" ]
      provider {
          key_arn = var.kms_arn
      }
    }
  }

  enabled_cluster_log_types = var.eks_logging

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
  ]
}

resource "aws_eks_node_group" "eks_node_group" {

  cluster_name    = var.cluster_name
  node_group_name = format("%s-%s", var.cluster_name, local.default_node_group_name)

  node_role_arn = aws_iam_role.node.arn
  subnet_ids    = data.aws_subnet_ids.private.ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  capacity_type = var.capacity_type
  disk_size     = var.disk_size
  instance_types = [
    var.node_instance_type
  ]

  # labels = var.labels

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy
  ]

  tags = merge({
    Name = format("%s-%s", var.cluster_name, local.default_node_group_name)
  }, var.tags)
}


resource "aws_eks_node_group" "addons" {
  for_each = var.node_pools

  cluster_name    = var.cluster_name
  node_group_name = format("%s-%s", var.cluster_name, each.key)

  node_role_arn = aws_iam_role.node.arn
  subnet_ids    = data.aws_subnet_ids.private.ids

  capacity_type = each.value.capacity_type
  disk_size     = each.value.disk_size
  instance_types = [
    each.value.node_instance_type
  ]

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  # labels = each.value.labels

  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy
  ]

  tags = merge({
    Name = format("%s-%s", var.cluster_name, each.key)
  }, var.tags)

}
