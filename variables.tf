# Copyright (C) 2020-2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>
#
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

#############################################################################
# Provider



#############################################################################
# Networking

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Tags for private subnets"
  default = {
    "made-by" = "terraform"
  }
}

#variable "public_subnet_tags" {
#  type        = map(string)
#  description = "Tags for public subnets"
#  default = {
#    "made-by" = "terraform"
#  }
#}

#############################################################################
# Kubernetes cluster

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "The EKS Kubernetes version"
}

variable "desired_size" {
  default     = 2
  type        = string
  description = "Autoscaling Desired node capacity"
}

variable "max_size" {
  default     = 5
  type        = string
  description = "Autoscaling maximum node capacity"
}

variable "min_size" {
  default     = 1
  type        = string
  description = "Autoscaling Minimum node capacity"
}

variable "tags" {
  type        = map(string)
  description = "Tags associated to the resources"
  default = {
    "made-by" = "terraform"
  }
}

variable "capacity_type" {
  type        = string
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT"
}

variable "disk_size" {
  type        = number
  description = " Disk size in GiB for worker nodes."
  default     = 20
}

variable "node_instance_type" {
  type        = string
  description = "Worker Node EC2 instance type"
}

variable "eks_logging" {
  type        = list(string)
  description = "A list of the desired control plane logging to enable"
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "which CIDR blocks can access the Amazon EKS public API server endpoint"
}

variable "enable_kms" {
  type        = bool
  description = "Enable encryption configuration for the cluster"
}

variable "kms_arn" {
  type        = string
  description = "ARN of the Key Management Service (KMS) customer master key (CMK)."
}

#############################################################################
# Addons node pool

variable "node_pools" {
  description = "Addons node pools"
  type = map(object({
    desired_size       = number
    node_instance_type = string
    max_size           = number
    min_size           = number
    capacity_type      = string
    disk_size          = number
  }))
  default = {}
}

#############################################################################
# Secret Manager

variable "recovery_window_in_days" {
  type        = number
  description = "Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days."
  default     = 30
}

#############################################################################
# EBS CSI Driver

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace for ebs-csi driver"
  default     = "kube-system"
}

variable "service_accounts" {
  type        = list(string)
  description = "The Kubernetes service account for ebs-csi driver"
  default = [
    "ebs-csi-controller-sa",
    "ebs-snapshot-controller"
  ]
}
