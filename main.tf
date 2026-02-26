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

resource "google_network_security_authz_policy" "authz_policy" {
  project     = var.project_id
  name        = var.name
  location    = var.location
  action      = var.action
  description = var.description
  labels      = var.labels

  target {
    load_balancing_scheme = var.load_balancing_scheme
    resources             = var.target_resources
  }

  dynamic "http_rules" {
    for_each = var.http_rules
    content {
      when = http_rules.value.when

      dynamic "from" {
        for_each = http_rules.value.from != null ? [http_rules.value.from] : []
        content {
          # Sources matching
          dynamic "sources" {
            for_each = from.value.sources != null ? [from.value.sources] : []
            content {
              dynamic "principals" {
                for_each = sources.value.principals
                content {
                  principal_selector = principals.value.selector
                  # Deprecation fix: all match criteria moved inside 'principal' block
                  principal {
                    exact       = principals.value.exact
                    prefix      = principals.value.prefix
                    suffix      = principals.value.suffix
                    contains    = principals.value.contains
                    ignore_case = principals.value.ignore_case
                  }
                }
              }
              dynamic "ip_blocks" {
                for_each = sources.value.ip_blocks
                content {
                  prefix = split("/", ip_blocks.value)[0]
                  length = tonumber(split("/", ip_blocks.value)[1])
                }
              }
            }
          }

          # Negated Sources matching
          dynamic "not_sources" {
            for_each = from.value.not_sources != null ? [from.value.not_sources] : []
            content {
              dynamic "principals" {
                for_each = not_sources.value.principals
                content {
                  principal_selector = principals.value.selector
                  principal {
                    exact       = principals.value.exact
                    ignore_case = principals.value.ignore_case
                  }
                }
              }
              dynamic "ip_blocks" {
                for_each = not_sources.value.ip_blocks
                content {
                  prefix = split("/", ip_blocks.value)[0]
                  length = tonumber(split("/", ip_blocks.value)[1])
                }
              }
            }
          }
        }
      }

      dynamic "to" {
        for_each = http_rules.value.to != null ? [http_rules.value.to] : []
        content {
          dynamic "operations" {
            for_each = to.value.operations != null ? [to.value.operations] : []
            content {
              methods = operations.value.methods

              dynamic "hosts" {
                for_each = operations.value.hosts
                content {
                  exact       = hosts.value.exact
                  prefix      = hosts.value.prefix
                  suffix      = hosts.value.suffix
                  contains    = hosts.value.contains
                  ignore_case = hosts.value.ignore_case
                }
              }

              header_set {
                dynamic "headers" {
                  for_each = operations.value.headers
                  content {
                    name = headers.value.name
                    value {
                      exact       = headers.value.exact
                      prefix      = headers.value.prefix
                      suffix      = headers.value.suffix
                      contains    = headers.value.contains
                      ignore_case = headers.value.ignore_case
                    }
                  }
                }
              }
            }
          }

          dynamic "not_operations" {
            for_each = to.value.not_operations != null ? [to.value.not_operations] : []
            content {
              methods = not_operations.value.methods
              dynamic "hosts" {
                for_each = not_operations.value.hosts
                content {
                  exact = hosts.value.exact
                }
              }
            }
          }
        }
      }
    }
  }

}