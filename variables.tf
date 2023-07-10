variable "environment" {
  description = "Environment name. Will be used along with `project_name` as a prefix for all resources."
  type        = string
}

variable "project_name" {
  description = "Project name. Will be used along with `environment` as a prefix for all resources."
  type        = string
}

variable "azure_location" {
  description = "Azure location in which to launch resources."
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}

variable "key_vault_access_users" {
  description = "List of users that require access to the Key Vault where tfvars are stored. This should be a list of User Principle Names (Found in Active Directory) that need to run terraform"
  type        = list(string)
}

variable "key_vault_access_ipv4" {
  description = "List of IPv4 Addresses that are permitted to access the Key Vault"
  type        = list(string)
}

variable "tfvars_filename" {
  description = "tfvars filename. This file is uploaded and stored encrupted within Key Vault, to ensure that the latest tfvars are stored in a shared place."
  type        = string
}

variable "key_vault_app_gateway_certificates_access_users" {
  description = "List of users that require access to the App Gateway Certificates Key Vault. This should be a list of User Principle Names (Found in Active Directory) that need to run terraform"
  type        = list(string)
}

variable "key_vault_app_gateway_certificates_access_ipv4" {
  description = "List of IPv4 Addresses that are permitted to access the App Gateway Certificates Key Vault"
  type        = list(string)
}

variable "key_vault_app_gateway_certificates_access_subnet_ids" {
  description = "List of Azure Subnet IDs that are permitted to access the App Gateway Certificates Key Vault"
  type        = list(string)
  default     = []
}

variable "key_vault_tfvars_enable_log_analytics_workspace" {
  description = "When enabled, creates a Log Analyics Workspace for the tfvars Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_tfvars_enable_diagnostic_storage_account" {
  description = "When enabled, creates a Storage Account for the tfvars key vault diagnostic logs"
  type        = bool
  default     = true
}

variable "response_request_timeout" {
  description = "Azure CDN Front Door response or App Gateway V2 request timeout in seconds"
  type        = number
}

variable "enable_waf" {
  description = "Enable WAF"
  type        = bool
  default     = false
}

variable "waf_application" {
  description = "Which product to apply the WAF to. Must be either CDN or AppGatewayV2"
  type        = string
}

variable "waf_mode" {
  description = "WAF mode"
  type        = string
}

variable "container_app_targets" {
  description = "A map of Container Apps to configure as Front Door or App Gateway V2 targets"
  type = map(object({
    resource_group : string,
    create_custom_domain : optional(bool, false),
    enable_health_probe : optional(bool, true),
    health_probe_interval : optional(number, 60),
    health_probe_request_type : optional(string, "HEAD"),
    health_probe_path : optional(string, "/"),
    cdn_add_response_headers : optional(list(object({
      name : string,
      value : string
      })
    ), []),
    cdn_add_request_headers : optional(list(object({
      name : string,
      value : string
      })
    ), []),
    cdn_remove_response_headers : optional(list(string), []),
    cdn_remove_request_headers : optional(list(string), [])
  }))
  default = {}
}

variable "web_app_service_targets" {
  description = "A map of Web App Services to configure as Front Door or App Gateway V2 targets"
  type = map(object({
    resource_group : string,
    os : string
    create_custom_domain : optional(bool, false),
    enable_health_probe : optional(bool, true)
    health_probe_interval : optional(number, 60),
    health_probe_request_type : optional(string, "HEAD"),
    health_probe_path : optional(string, "/"),
    cdn_add_response_headers : optional(list(object({
      name : string,
      value : string
      })
    ), []),
    cdn_add_request_headers : optional(list(object({
      name : string,
      value : string
      })
    ), []),
    cdn_remove_response_headers : optional(list(string), []),
    cdn_remove_request_headers : optional(list(string), [])
  }))
  default = {}
}

variable "cdn_add_response_headers" {
  description = "List of response headers to add at the CDN Front Door for all endpoints `[{ \"Name\" = \"Strict-Transport-Security\", \"value\" = \"max-age=31536000\" }]`"
  type        = list(map(string))
  default     = []
}

variable "cdn_remove_response_headers" {
  description = "List of response headers to remove at the CDN Front Door for all endpoints"
  type        = list(string)
  default     = []
}
