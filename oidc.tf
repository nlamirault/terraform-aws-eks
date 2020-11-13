# Copyright (C) 2020 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_secretsmanager_secret" "oidc_url" {
  name        = format("%s_oidc_url", replace(var.cluster_name, "-", "_"))
  description = "OpenID Connect Provider URL"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "oidc_url" {
  secret_id     = aws_secretsmanager_secret.oidc_url.id
  secret_binary = base64encode(aws_iam_openid_connect_provider.eks.url)
}

resource "aws_secretsmanager_secret" "oidc_arn" {
  name        = format("%s_oidc_arn", replace(var.cluster_name, "-", "_"))
  description = "OpenID Connect Provider ARN"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "oidc_arn" {
  secret_id     = aws_secretsmanager_secret.oidc_arn.id
  secret_binary = base64encode(aws_iam_openid_connect_provider.eks.arn)
}
