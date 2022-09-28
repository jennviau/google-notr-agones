/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "fleet_membership" {
  value = google_container_aws_cluster.this.fleet[0].membership
}
output "api_role_arn" {
  description = "ARN of the actuated IAM role resource"
  value       = aws_iam_role.api_role.arn
}

output "cp_instance_profile_id" {
  description = "IAM instance profile of controlplane"
  value       = aws_iam_instance_profile.cp_instance_profile.id
}

output "np_instance_profile_id" {
  description = "IAM instance profile of nodepool"
  value       = aws_iam_instance_profile.np_instance_profile.id
}
output "database_encryption_kms_key_arn" {
  description = "ARN of the actuated KMS key resource for cluster secret encryption"
  value       = aws_kms_key.database_encryption_kms_key.arn
}

output "control_plane_config_encryption_kms_key_arn" {
  description = "ARN of the actuated KMS key resource for cluster control plane user data encryption"
  value       = aws_kms_key.control_plane_config_encryption_kms_key.arn
}

output "control_plane_main_volume_encryption_kms_key_arn" {
  description = "ARN of the actuated KMS key resource for cluster control plane main volume encryption"
  value       = aws_kms_key.control_plane_main_volume_encryption_kms_key.arn
}

output "control_plane_root_volume_encryption_kms_key_arn" {
  description = "ARN of the actuated KMS key resource for cluster control plane root volume encryption"
  value       = aws_kms_key.control_plane_root_volume_encryption_kms_key.arn
}

output "node_pool_config_encryption_kms_key_arn" {
  description = "ARN of the actuated KMS key resource for cluster node pool user data encryption"
  value       = aws_kms_key.node_pool_config_encryption_kms_key.arn
}

output "node_pool_root_volume_encryption_kms_key_arn" {
  description = "ARN of the actuated KMS key resource for cluster node pool root volume encryption"
  value       = aws_kms_key.node_pool_root_volume_encryption_kms_key.arn
}

output "aws_vpc_id" {
  description = "ARN of the actuated KMS key resource for cluster secret encryption"
  value       = aws_vpc.this.id
}
output "aws_cp_subnet_id_1" {
  description = "private subnet ID of control plane 1"
  value       = aws_subnet.private_cp[0].id
}

output "aws_cp_subnet_id_2" {
  description = "private subnet ID of control plane 2"
  value       = aws_subnet.private_cp[1].id
}
output "aws_cp_subnet_id_3" {
  description = "private subnet ID of control plane 3"
  value       = aws_subnet.private_cp[2].id
}