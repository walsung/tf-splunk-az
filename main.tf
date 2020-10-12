
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.44.0"

    #retrieve id and tenantid from azure-cli:    az account list
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "rg_splunk" {
  name     = var.resource_group_name
  location = var.location
  tags = {
      environment = "testing"
  }
}


resource "azurerm_container_group" "common-instances" {
  for_each = var.common_instance
  name                = each.value.name
  location            = azurerm_resource_group.rg_splunk.location
  resource_group_name = azurerm_resource_group.rg_splunk.name
  ip_address_type     = "public"
  dns_name_label      = each.value.name
  os_type             = "linux"

  container {
    name   = "splunk"
    image  = "splunk/splunk:latest"
    cpu    = local.common_cpu
    memory = local.common_ram
    ports {
      port     = local.webport
      protocol = "TCP"
    }
    ports {
      port     = local.mgmtport
      protocol = "TCP"
    }
    environment_variables = {
      SPLUNK_START_ARGS        = "--accept-license"
      SPLUNK_PASSWORD          = var.login_password 
    }
  }

  tags = {
    environment = "testing"
  }
}

# resource "azurerm_container_group" "masternode" {
#   name                = var.masternode.name
#   location            = azurerm_resource_group.rg_splunk.location
#   resource_group_name = azurerm_resource_group.rg_splunk.name
#   ip_address_type     = "public"
#   dns_name_label      = var.masternode.name
#   os_type             = "linux"

#   container {
#     name   = "splunk"
#     image  = "splunk/splunk:latest"
#     cpu    = "2"
#     memory = "2"
#     ports {
#       port     = 8000
#       protocol = "TCP"
#     }
#     ports {
#       port     = 8089
#       protocol = "TCP"
#     }
#     environment_variables = {
#       SPLUNK_START_ARGS        = "--accept-license"
#       SPLUNK_PASSWORD          = var.login_password 
#     }
#   }

#   tags = {
#     environment = "testing"
#   }
# }


# resource "azurerm_container_group" "deployer" {
#   name                = var.masternode
#   location            = azurerm_resource_group.rg_splunk.location
#   resource_group_name = azurerm_resource_group.rg_splunk.name
#   ip_address_type     = "public"
#   dns_name_label      = var.masternode
#   os_type             = "linux"

#   container {
#     name   = "splunk"
#     image  = "splunk/splunk:latest"
#     cpu    = "2"
#     memory = "2"
#     ports {
#       port     = 8000
#       protocol = "TCP"
#     }
#     ports {
#       port     = 8089
#       protocol = "TCP"
#     }
#     environment_variables = {
#       SPLUNK_START_ARGS        = "--accept-license"
#       SPLUNK_PASSWORD          = var.login_password 
#     }
#   }

#   tags = {
#     environment = "testing"
#   }
# }