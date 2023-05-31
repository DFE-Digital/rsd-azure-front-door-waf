module "azurerm_front_door_waf" {
  source = "github.com/DFE-Digital/terraform-azurerm-front-door-app-gateway-waf?ref=conditionally-use-app-gateway"

  environment    = local.environment
  project_name   = local.project_name
  azure_location = local.azure_location

  response_request_timeout = local.response_request_timeout

  enable_waf       = local.enable_waf
  waf_mode         = local.waf_mode
  waf_application  = local.waf_application
  waf_targets      = local.waf_targets
  waf_custom_rules = local.waf_custom_rules

  tags = local.tags
}
