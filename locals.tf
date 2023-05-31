locals {
  environment    = var.environment
  project_name   = var.project_name
  azure_location = var.azure_location

  response_request_timeout = var.response_request_timeout

  container_app_targets   = var.container_app_targets
  web_app_service_targets = var.web_app_service_targets
  windows_web_app_service_targets = {
    for web_app_service_target_name, web_app_service_target_value in local.web_app_service_targets : web_app_service_target_name => web_app_service_target_value if web_app_service_target_value.os == "Windows"
  }
  linux_web_app_service_targets = {
    for web_app_service_target_name, web_app_service_target_value in local.web_app_service_targets : web_app_service_target_name => web_app_service_target_value if web_app_service_target_value.os == "Linux"
  }

  enable_waf       = var.enable_waf
  waf_application  = var.waf_application
  waf_mode         = var.waf_mode
  waf_custom_rules = var.waf_custom_rules
  waf_targets = merge(
    {
      for container_app_target_name, container_app_target_value in local.container_app_targets : replace(container_app_target_name, local.environment, "") => merge(
        {
          domain = jsondecode(data.azapi_resource.container_apps[container_app_target_name].output).properties.configuration.ingress.fqdn
        },
        container_app_target_value
      )
    },
    {
      for windows_web_app_service_target_name, windows_web_app_service_target_value in local.windows_web_app_service_targets : replace(windows_web_app_service_target_name, local.environment, "") => merge(
        {
          domain = data.azurerm_windows_web_app.web_apps[windows_web_app_service_target_name].default_hostname
        },
        windows_web_app_service_target_value
      )
    },
    {
      for linux_web_app_service_target_name, linux_web_app_service_target_value in local.linux_web_app_service_targets : replace(linux_web_app_service_target_name, local.environment, "") => merge(
        {
          domain = data.azurerm_linux_web_app.web_apps[linux_web_app_service_target_name].default_hostname
        },
        linux_web_app_service_target_value
      )
    }
  )

  tags = var.tags
}
