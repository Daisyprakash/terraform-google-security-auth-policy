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

# The versions.tf file is used to specify the required Terraform version and provider requirements.
terraform {
  # Specifies the minimum required version of Terraform to run this module.
  required_version = ">= 1.3.0"
  required_providers {
    # The google-beta provider is used to manage Google Cloud Platform resources.
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.3.0"
    }
    # The random provider is used to generate random values.
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}