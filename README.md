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
| description | A free-text description of the Authorization Policy. | `string` | `null` | no |
| labels | A map of labels to attach to the Authorization Policy. | `map(string)` | `{}` | no |
| location | The location of the authorization policy. Can be 'global' or a region. | `string` | `"global"` | no |
| name | The name of the Authorization Policy. If not provided, a random name will be generated. | `string` | `null` | no |
| project\_id | The project ID in which the Authorization Policy will be created. If not provided, the provider project is used. | `string` | n/a | yes |
| rules | A list of rules that match traffic. A rule consists of a list of sources and a list of destinations.<br>If a traffic is matched by multiple rules, the first matched rule will be enforced.<br>If no rule is matched, the default action is enforced.<br>Each rule object can have the following attributes:<br>- `sources`: (Optional) A list of source specifications. A source specifies a list of identities or a list of IP blocks. Max 1 item.<br>  - `principals`: (Optional) A list of peer identities to match for authorization.<br>  - `ip_blocks`: (Optional) A list of CIDR ranges to match for authorization.<br>- `destinations`: (Optional) A list of destination specifications. A destination specifies a list of hosts, ports, methods, and a header matcher. Max 1 item.<br>  - `hosts`: (Required) A list of host names or FQDNs.<br>  - `ports`: (Required) A list of destination ports to match.<br>  - `methods`: (Optional) A list of HTTP methods to match.<br>  - `http_header_match`: (Optional) A HTTP header matcher. Max 1 item.<br>    - `header_name`: (Required) The name of the HTTP header to match.<br>    - `regex_match`: (Required) The value of the header must match the regular expression. | <pre>list(object({<br>    sources = optional(list(object({<br>      principals = optional(list(string), [])<br>      ip_blocks  = optional(list(string), [])<br>    })), [])<br>    destinations = optional(list(object({<br>      hosts   = list(string)<br>      ports   = list(number)<br>      methods = optional(list(string), [])<br>      http_header_match = optional(list(object({<br>        header_name = string<br>        regex_match = string<br>      })), [])<br>    })), [])<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| create\_time | The timestamp when the authorization policy was created. |
| id | The canonical ID of the authorization policy, in the format `projects/{project}/locations/{location}/authorizationPolicies/{name}`. |
| name | The name of the authorization policy. |
| update\_time | The timestamp when the authorization policy was last updated. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->