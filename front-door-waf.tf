module "azurerm_front_door_waf" {
  source = "github.com/DFE-Digital/terraform-azurerm-front-door-waf?ref=add-custom-app-gateway-probes"

  environment    = local.environment
  project_name   = local.project_name
  azure_location = local.azure_location

  response_request_timeout = local.response_request_timeout

  waf_targets = local.waf_targets

  enable_waf      = local.enable_waf
  waf_application = local.waf_application
  waf_mode        = local.waf_mode
  # waf_managed_rulesets = local.waf_managed_rulesets
  # waf_custom_rules     = local.waf_custom_rules

  key_vault_app_gateway_certificates_access_users      = local.key_vault_app_gateway_certificates_access_users
  key_vault_app_gateway_certificates_access_ipv4       = local.key_vault_app_gateway_certificates_access_ipv4
  key_vault_app_gateway_certificates_access_subnet_ids = local.key_vault_app_gateway_certificates_access_subnet_ids

  cdn_add_response_headers    = local.cdn_add_response_headers
  cdn_remove_response_headers = local.cdn_remove_response_headers

  tags = local.tags
}
