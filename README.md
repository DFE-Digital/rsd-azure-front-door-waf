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
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 1.5.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.52.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azurerm_front_door_waf"></a> [azurerm\_front\_door\_waf](#module\_azurerm\_front\_door\_waf) | github.com/DFE-Digital/terraform-azurerm-front-door-app-gateway-waf | conditionally-use-app-gateway |

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
| <a name="input_container_app_targets"></a> [container\_app\_targets](#input\_container\_app\_targets) | A map of Container Apps to configure as CDN targets | <pre>map(object({<br>    resource_group : string,<br>    create_custom_domain : optional(bool, false),<br>    enable_health_probe : optional(bool, true)<br>    health_probe_interval : optional(number, 60),<br>    health_probe_request_type : optional(string, "HEAD"),<br>    health_probe_path : optional(string, "/")<br>  }))</pre> | `{}` | no |
| <a name="input_enable_waf"></a> [enable\_waf](#input\_enable\_waf) | Enable CDN Front Door WAF | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. Will be used along with `project_name` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name. Will be used along with `environment` as a prefix for all resources. | `string` | n/a | yes |
| <a name="input_response_request_timeout"></a> [response\_request\_timeout](#input\_response\_request\_timeout) | Azure CDN Front Door response timeout, or app gateway v2 request timeout in seconds | `number` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all resources | `map(string)` | n/a | yes |
| <a name="input_waf_application"></a> [waf\_application](#input\_waf\_application) | Which product to apply the WAF to. Must be either CDN or AppGatewayV2 | `string` | n/a | yes |
| <a name="input_waf_custom_rules"></a> [waf\_custom\_rules](#input\_waf\_custom\_rules) | Map of all Custom rules you want to apply to the WAF | <pre>map(object({<br>    priority : number,<br>    action : string,<br>    match_conditions : map(object({<br>      match_variable : string,<br>      match_values : list(string),<br>      operator : string,<br>      selector : optional(string, null)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_waf_mode"></a> [waf\_mode](#input\_waf\_mode) | CDN Front Door WAF mode | `string` | n/a | yes |
| <a name="input_web_app_service_targets"></a> [web\_app\_service\_targets](#input\_web\_app\_service\_targets) | A map of Web App Services to configure as CDN targets | <pre>map(object({<br>    resource_group : string,<br>    os : string<br>    create_custom_domain : optional(bool, false),<br>    enable_health_probe : optional(bool, true)<br>    health_probe_interval : optional(number, 60),<br>    health_probe_request_type : optional(string, "HEAD"),<br>    health_probe_path : optional(string, "/")<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
