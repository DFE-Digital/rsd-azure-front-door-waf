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

variable "response_request_timeout" {
  description = "Azure CDN Front Door response timeout, or app gateway v2 request timeout in seconds"
  type        = number
}

variable "enable_waf" {
  description = "Enable CDN Front Door WAF"
  type        = bool
  default     = false
}

variable "waf_mode" {
  description = "CDN Front Door WAF mode"
  type        = string
}

variable "waf_application" {
  description = "Which product to apply the WAF to. Must be either CDN or AppGatewayV2"
  type        = string
  validation {
    condition     = contains(["CDN", "AppGatewayV2"], var.waf_application)
    error_message = "waf_application must be either CDN or AppGatewayV2"
  }
}

variable "waf_custom_rules" {
  description = "Map of all Custom rules you want to apply to the WAF"
  type = map(object({
    priority : number,
    action : string,
    match_conditions : map(object({
      match_variable : string,
      match_values : list(string),
      operator : string,
      selector : optional(string, null)
    }))
  }))
  default = {}
}

variable "container_app_targets" {
  description = "A map of Container Apps to configure as CDN targets"
  type = map(object({
    resource_group : string,
    create_custom_domain : optional(bool, false),
    enable_health_probe : optional(bool, true)
    health_probe_interval : optional(number, 60),
    health_probe_request_type : optional(string, "HEAD"),
    health_probe_path : optional(string, "/")
  }))
  default = {}
}

variable "web_app_service_targets" {
  description = "A map of Web App Services to configure as CDN targets"
  type = map(object({
    resource_group : string,
    os : string
    create_custom_domain : optional(bool, false),
    enable_health_probe : optional(bool, true)
    health_probe_interval : optional(number, 60),
    health_probe_request_type : optional(string, "HEAD"),
    health_probe_path : optional(string, "/")
  }))
  default = {}
}
