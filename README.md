# Google Cloud Network Services AuthzExtension

This module creates a `google_network_services_authz_extension` resource, which allows for flexible authorization policies in a service mesh by integrating with an external gRPC authorizer. It is used to configure how traffic is authorized before it reaches a backend service.

## Usage

Here is a basic example of how to use this module:

```hcl
module "authz_extension" {
  source                  = "./" # Or a path to this module
  project_id              = "your-gcp-project-id"
  name                    = "my-custom-authz-extension"
  location                = "global"
  service                 = "projects/your-gcp-project-id/global/backendServices/my-ext-authz-backend-service"
  authority               = "auth.example.com"
  timeout                 = "5s"
  load_balancing_scheme   = "INTERNAL_MANAGED"
  description             = "Authorization extension for my service mesh."
  labels = {
    env = "production"
  }
}
```

## Requirements

The following requirements are needed by this module.

### Software

The following software is required:
- [Terraform](https://www.terraform.io/downloads.html) >= 1.3
- [Terraform Provider for GCP](https://github.com/hashicorp/terraform-provider-google) ~> 5.25

### APIs

The following APIs must be enabled on the project:
- [Network Services API](https://console.cloud.google.com/apis/library/networkservices.googleapis.com): `networkservices.googleapis.com`

### Permissions

The service account or user account executing Terraform must have the following permissions on the project:
- `networkservices.authzExtensions.create`
- `networkservices.authzExtensions.get`
- `networkservices.authzExtensions.update`
- `networkservices.authzExtensions.delete`

The predefined `roles/networkservices.admin` role contains the necessary permissions.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| action | The action to take when a rule match is found. Possible values are 'ALLOW' or 'DENY'. | `string` | `"ALLOW"` | no |
| custom\_provider | Required if action is CUSTOM. Configuration for Authz Extension or Cloud IAP. | <pre>object({<br>    authz_extension = optional(object({<br>      resources = list(string)<br>    }))<br>    cloud_iap = optional(object({<br>      enabled = bool<br>    }))<br>  })</pre> | `null` | no |
| description | A free-text description of the Authorization Policy. | `string` | `null` | no |
| http\_rules | Complete nested structure for Authz Policy HTTP Rules. | <pre>list(object({<br>    when = optional(string)<br>    from = optional(object({<br>      sources = optional(object({<br>        ip_blocks = optional(list(string), [])<br>        principals = optional(list(object({<br>          selector    = optional(string, "CLIENT_CERT_URI_SAN")<br>          exact       = optional(string)<br>          prefix      = optional(string)<br>          suffix      = optional(string)<br>          contains    = optional(string)<br>          ignore_case = optional(bool, false)<br>        })), [])<br>        resources = optional(list(object({<br>          tag_value_id_set = optional(list(string))<br>          iam_service_account = optional(object({ # Upgraded to object<br>            exact       = optional(string)<br>            prefix      = optional(string)<br>            suffix      = optional(string)<br>            contains    = optional(string)<br>            ignore_case = optional(bool, false)<br>          }))<br>        })), [])<br>      }))<br>      not_sources = optional(object({<br>        ip_blocks = optional(list(string), [])<br>        principals = optional(list(object({<br>          selector    = optional(string, "CLIENT_CERT_URI_SAN")<br>          exact       = optional(string)<br>          ignore_case = optional(bool, false)<br>        })), [])<br>        resources = optional(list(object({<br>          tag_value_id_set = optional(list(string))<br>          iam_service_account = optional(object({ # Upgraded to object<br>            exact       = optional(string)<br>            prefix      = optional(string)<br>            suffix      = optional(string)<br>            contains    = optional(string)<br>            ignore_case = optional(bool, false)<br>          }))<br>        })), [])<br>      }))<br>    }))<br>    to = optional(object({<br>      operations = optional(object({<br>        methods = optional(list(string), [])<br>        paths = optional(list(object({ # Upgraded to object<br>          exact       = optional(string)<br>          prefix      = optional(string)<br>          suffix      = optional(string)<br>          contains    = optional(string)<br>          ignore_case = optional(bool, false)<br>        })), [])<br>        hosts = optional(list(object({<br>          exact       = optional(string)<br>          prefix      = optional(string)<br>          suffix      = optional(string)<br>          contains    = optional(string)<br>          ignore_case = optional(bool, false)<br>        })), [])<br>        headers = optional(list(object({<br>          name        = string<br>          exact       = optional(string)<br>          prefix      = optional(string)<br>          suffix      = optional(string)<br>          contains    = optional(string)<br>          ignore_case = optional(bool, false)<br>        })), [])<br>        mcp = optional(object({<br>          base_protocol_methods_option = optional(string)<br>          methods = list(object({<br>            name   = string<br>            params = optional(string)<br>          }))<br>        }))<br>      }))<br>      not_operations = optional(object({<br>        methods = optional(list(string), [])<br>        paths = optional(list(object({ # Upgraded to object<br>          exact       = optional(string)<br>          prefix      = optional(string)<br>          suffix      = optional(string)<br>          contains    = optional(string)<br>          ignore_case = optional(bool, false)<br>        })), [])<br>        hosts = optional(list(object({<br>          exact = string<br>        })), [])<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| labels | A map of labels to attach to the Authorization Policy. | `map(string)` | `{}` | no |
| location | The location of the authorization policy. Can be 'global' or a region. | `string` | `"global"` | no |
| name | The name of the Authorization Policy. If not provided, a random name will be generated. | `string` | n/a | yes |
| policy\_profile | Defines the type of authorization (REQUEST\_AUTHZ or CONTENT\_AUTHZ). | `string` | `null` | no |
| project\_id | The project ID in which the Authorization Policy will be created. If not provided, the provider project is used. | `string` | n/a | yes |
| target | The target resources and load balancing scheme this policy applies to. | <pre>object({<br>    load_balancing_scheme = optional(string, "INTERNAL_MANAGED")<br>    resources             = list(string)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| create\_time | The timestamp when the authz policy was created. |
| effective\_labels | All labels present on the resource in GCP. |
| id | The canonical ID of the authz policy. |
| name | The name of the authz policy. |
| terraform\_labels | The combination of labels configured directly and default provider labels. |
| update\_time | The timestamp when the authz policy was last updated. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->