/**
 * Copyright 2026 Google LLC
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

# The outputs.tf file is used to declare outputs from the module.
# The timestamp when the resource was created.
output "create_time" {
  description = "The timestamp when the authorization policy was created."
  value       = google_network_security_authorization_policy.authz_policy.create_time
}

# The canonical ID of the authorization policy.
output "id" {
  description = "The canonical ID of the authorization policy, in the format `projects/{project}/locations/{location}/authorizationPolicies/{name}`."
  value       = google_network_security_authorization_policy.authz_policy.id
}

# The name of the authorization policy.
output "name" {
  description = "The name of the authorization policy."
  value       = google_network_security_authorization_policy.authz_policy.name
}

# The timestamp when the resource was last updated.
output "update_time" {
  description = "The timestamp when the authorization policy was last updated."
  value       = google_network_security_authorization_policy.authz_policy.update_time
}