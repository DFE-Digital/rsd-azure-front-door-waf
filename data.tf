data "azurerm_resource_group" "container_apps" {
  for_each = local.container_app_targets

  name = each.value.resource_group
}

data "azapi_resource" "container_apps" {
  for_each = local.container_app_targets

  name      = each.key
  parent_id = data.azurerm_resource_group.container_apps[each.key].id
  type      = "Microsoft.App/containerApps@2022-03-01"

  response_export_values = [
    "properties.configuration.ingress.fqdn",
  ]
}

data "azurerm_windows_web_app" "web_apps" {
  for_each = local.windows_web_app_service_targets

  name                = each.key
  resource_group_name = each.value.resource_group
}

data "azurerm_linux_web_app" "web_apps" {
  for_each = local.linux_web_app_service_targets

  name                = each.key
  resource_group_name = each.value.resource_group
}
