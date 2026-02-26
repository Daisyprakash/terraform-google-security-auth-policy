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
variable "project_id" {
  description = "The project ID in which the Authorization Policy will be created. If not provided, the provider project is used."

  type = string
}

variable "name" {
  description = "The name of the Authorization Policy. If not provided, a random name will be generated."

  type = string
}

variable "location" {
  description = "The location of the authorization policy. Can be 'global' or a region."

  type    = string
  default = "global"
}

variable "action" {
  description = "The action to take when a rule match is found. Possible values are 'ALLOW' or 'DENY'."

  type    = string
  default = "ALLOW"
}

variable "load_balancing_scheme" {
  description = "Possible values: INTERNAL_MANAGED, EXTERNAL_MANAGED, INTERNAL_SELF_MANAGED."
  type        = string
  default     = "INTERNAL_MANAGED"
}

variable "target_resources" {
  description = "List of Forwarding Rule URLs."
  type        = list(string)
}

variable "description" {
  description = "A free-text description of the Authorization Policy."
  type        = string
  default     = null
}

variable "labels" {
  description = "A map of labels to attach to the Authorization Policy."
  type        = map(string)
  default     = {}
}

variable "http_rules" {
  description = "Complete nested structure for Authz Policy HTTP Rules."
  type = list(object({
    when = optional(string)
    from = optional(object({
      sources = optional(object({
        ip_blocks = optional(list(string), [])
        principals = optional(list(object({
          selector    = optional(string, "CLIENT_CERT_URI_SAN")
          exact       = optional(string)
          prefix      = optional(string)
          suffix      = optional(string)
          contains    = optional(string)
          ignore_case = optional(bool, false)
        })), [])
      }))
      not_sources = optional(object({
        ip_blocks = optional(list(string), [])
        principals = optional(list(object({
          selector    = optional(string, "CLIENT_CERT_URI_SAN")
          exact       = optional(string)
          ignore_case = optional(bool, false)
        })), [])
      }))
    }))
    to = optional(object({
      operations = optional(object({
        methods = optional(list(string), [])
        hosts = optional(list(object({
          exact       = optional(string)
          prefix      = optional(string)
          suffix      = optional(string)
          contains    = optional(string)
          ignore_case = optional(bool, false)
        })), [])
        headers = optional(list(object({
          name        = string
          exact       = optional(string)
          prefix      = optional(string)
          suffix      = optional(string)
          contains    = optional(string)
          ignore_case = optional(bool, false)
        })), [])
      }))
      not_operations = optional(object({
        methods = optional(list(string), [])
        hosts = optional(list(object({
          exact = string
        })), [])
      }))
    }))
  }))
  default = []
}