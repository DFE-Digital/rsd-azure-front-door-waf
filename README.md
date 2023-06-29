# rsd-azure-front-door-waf
Azure Front Door WAF for RSD

[![Terraform CI](https://github.com/DFE-Digital/rsd-azure-front-door-waf/actions/workflows/continuous-integration-terraform.yml/badge.svg?branch=main)](https://github.com/DFE-Digital/rsd-azure-front-door-waf/actions/workflows/continuous-integration-terraform.yml/?branch=main)
[![Tflint](https://github.com/DFE-Digital/rsd-azure-front-door-waf/actions/workflows/continuous-integration-tflint.yml/badge.svg?branch=main)](https://github.com/DFE-Digital/rsd-azure-front-door-waf/actions/workflows/continuous-integration-tflint.yml?branch=main)
[![Tfsec](https://github.com/DFE-Digital/rsd-azure-front-door-waf/actions/workflows/continuous-integration-tfsec.yml/badge.svg?branch=main)](https://github.com/DFE-Digital/rsd-azure-front-door-waf/actions/workflows/continuous-integration-tfsec.yml?branch=main)

#### Configuring the storage backend

The Terraform state is stored remotely in Azure, this allows multiple team members to
make changes and means the state file is backed up. The state file contains
sensitive information so access to it should be restricted, and it should be stored
encrypted at rest.

##### Create a new storage backend

This step only needs to be done once per environment.
If it has already been created, obtain the storage backend attributes and skip to the next step.

The [Azure tutorial](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage) outlines the steps to create a storage account and container for the state file. You will need:

- subscription_id: The id of the azure Subscription the resource group belongs to
- resource_group_name: The name of the resource group used for the Azure Storage account.
- storage_account_name: The name of the Azure Storage account.
- container_name: The name of the blob container.
- key: The name of the state store file to be created.

##### Create a backend configuration file

Create a new file named `backend.vars` with the following content:

```
subscription_id      = [the ID of the Azure subscription]
resource_group_name  = [the name of the Azure resource group]
storage_account_name = [the name of the Azure Storage account]
container_name       = [the name of the blob container]
key                  = "terraform.tstate"
```

#### Azure resources

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.4 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.51.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 1.7.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.63.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azurerm_front_door_waf"></a> [azurerm\_front\_door\_waf](#module\_azurerm\_front\_door\_waf) | github.com/DFE-Digital/terraform-azurerm-front-door-waf | conditionally-use-app-gateway |
| <a name="module_azurerm_key_vault"></a> [azurerm\_key\_vault](#module\_azurerm\_key\_vault) | github.com/DFE-Digital/terraform-azurerm-key-vault-tfvars | v0.2.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.container_apps](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/resource) | data source |
| [azurerm_linux_web_app.web_apps](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/linux_web_app) | data source |
| [azurerm_resource_group.container_apps](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_windows_web_app.web_apps](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/windows_web_app) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Azure location in which to launch resources. | `string` | n/a | yes |
| <a name="input_cdn_add_response_headers"></a> [cdn\_add\_response\_headers](#input\_cdn\_add\_response\_headers) | List of response headers to add at the CDN Front Door for all endpoints `[{ "Name" = "Strict-Transport-Security", "value" = "max-age=31536000" }]` | `list(map(string))` | `[]` | no |
| <a name="input_cdn_remove_response_headers"></a> [cdn\_remove\_response\_headers](#input\_cdn\_remove\_response\_headers) | List of response headers to remove at the CDN Front Door for all endpoints | `list(string)` | `[]` | no |
| <a name="input_container_app_targets"></a> [container\_app\_targets](#input\_container\_app\_targets) | A map of Container Apps to configure as Front Door or App Gateway V2 targets | <pre>map(object({<br>    resource_group : string,<br>    create_custom_domain : optional(bool, false),<br>    enable_health_probe : optional(bool, true),<br>    health_probe_interval : optional(number, 60),<br>    health_probe_request_type : optional(string, "HEAD"),<br>    health_probe_path : optional(string, "/"),<br>    cdn_add_response_headers : optional(list(object({<br>      name : string,<br>      value : string<br>      })<br>    ), []),<br>    cdn_add_request_headers : optional(list(object({<br>      name : string,<br>      value : string<br>      })<br>    ), []),<br>    cdn_remove_response_headers : optional(list(string), []),<br>    cdn_remove_request_headers : optional(list(string), [])<br>  }))</pre> | `{}` | no |
| <a name="input_enable_waf"></a> [enable\_waf](#input\_enable\_waf) | Enable WAF | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. Will be used along with `project_name` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_key_vault_access_ipv4"></a> [key\_vault\_access\_ipv4](#input\_key\_vault\_access\_ipv4) | List of IPv4 Addresses that are permitted to access the Key Vault | `list(string)` | n/a | yes |
| <a name="input_key_vault_access_users"></a> [key\_vault\_access\_users](#input\_key\_vault\_access\_users) | List of users that require access to the Key Vault where tfvars are stored. This should be a list of User Principle Names (Found in Active Directory) that need to run terraform | `list(string)` | n/a | yes |
| <a name="input_key_vault_app_gateway_certificates_access_ipv4"></a> [key\_vault\_app\_gateway\_certificates\_access\_ipv4](#input\_key\_vault\_app\_gateway\_certificates\_access\_ipv4) | List of IPv4 Addresses that are permitted to access the App Gateway Certificates Key Vault | `list(string)` | n/a | yes |
| <a name="input_key_vault_app_gateway_certificates_access_subnet_ids"></a> [key\_vault\_app\_gateway\_certificates\_access\_subnet\_ids](#input\_key\_vault\_app\_gateway\_certificates\_access\_subnet\_ids) | List of Azure Subnet IDs that are permitted to access the App Gateway Certificates Key Vault | `list(string)` | `[]` | no |
| <a name="input_key_vault_app_gateway_certificates_access_users"></a> [key\_vault\_app\_gateway\_certificates\_access\_users](#input\_key\_vault\_app\_gateway\_certificates\_access\_users) | List of users that require access to the App Gateway Certificates Key Vault. This should be a list of User Principle Names (Found in Active Directory) that need to run terraform | `list(string)` | n/a | yes |
| <a name="input_key_vault_tfvars_enable_diagnostic_storage_account"></a> [key\_vault\_tfvars\_enable\_diagnostic\_storage\_account](#input\_key\_vault\_tfvars\_enable\_diagnostic\_storage\_account) | When enabled, creates a Storage Account for the tfvars key vault diagnostic logs | `bool` | `true` | no |
| <a name="input_key_vault_tfvars_enable_log_analytics_workspace"></a> [key\_vault\_tfvars\_enable\_log\_analytics\_workspace](#input\_key\_vault\_tfvars\_enable\_log\_analytics\_workspace) | When enabled, creates a Log Analyics Workspace for the tfvars Key Vault | `bool` | `true` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name. Will be used along with `environment` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_response_request_timeout"></a> [response\_request\_timeout](#input\_response\_request\_timeout) | Azure CDN Front Door response or App Gateway V2 request timeout in seconds | `number` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all resources | `map(string)` | n/a | yes |
| <a name="input_tfvars_filename"></a> [tfvars\_filename](#input\_tfvars\_filename) | tfvars filename. This file is uploaded and stored encrupted within Key Vault, to ensure that the latest tfvars are stored in a shared place. | `string` | n/a | yes |
| <a name="input_waf_application"></a> [waf\_application](#input\_waf\_application) | Which product to apply the WAF to. Must be either CDN or AppGatewayV2 | `string` | n/a | yes |
| <a name="input_waf_mode"></a> [waf\_mode](#input\_waf\_mode) | WAF mode | `string` | n/a | yes |
| <a name="input_web_app_service_targets"></a> [web\_app\_service\_targets](#input\_web\_app\_service\_targets) | A map of Web App Services to configure as Front Door or App Gateway V2 targets | <pre>map(object({<br>    resource_group : string,<br>    os : string<br>    create_custom_domain : optional(bool, false),<br>    enable_health_probe : optional(bool, true)<br>    health_probe_interval : optional(number, 60),<br>    health_probe_request_type : optional(string, "HEAD"),<br>    health_probe_path : optional(string, "/"),<br>    cdn_add_response_headers : optional(list(object({<br>      name : string,<br>      value : string<br>      })<br>    ), []),<br>    cdn_add_request_headers : optional(list(object({<br>      name : string,<br>      value : string<br>      })<br>    ), []),<br>    cdn_remove_response_headers : optional(list(string), []),<br>    cdn_remove_request_headers : optional(list(string), [])<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
