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

locals {
  default_node_group_name = "core"

  cluster_role     = format("%s-cluster", var.cluster_name)
  node_role        = format("%s-node", var.cluster_name)
  instance_profile = format("%s-instance-profile", var.cluster_name)
  ebs_csi          = format("%s-ebs-csi-controller", var.cluster_name)
}
