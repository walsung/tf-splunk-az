#set up remote state
terraform {
  backend "remote" {
    organization = "eclipse13"

    workspaces {
      name = "terr-cloud"
    }
  }
}


provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=2.31.1"
  features {}


  retrieve id and tenantid from azure-cli:    az account list
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

# resource "azurerm_resource_group" "rg_splunk" {
#   name     = var.resource_group_name
#   location = var.location
#   tags = {
#       environment = var.environment
#   }
# }

resource "azurerm_resource_group" "rg_splunk_jp" {
  name     = var.resource_group_name_jp
  location = var.location_jpe
  tags = {
      environment = var.environment
  }
}

resource "azurerm_resource_group" "rg_splunk_kr" {
  name     = var.resource_group_name_kr
  location = var.location_krs
  tags = {
      environment = var.environment
  }
}

resource "azurerm_resource_group" "rg_splunk_ue" {
  name     = var.resource_group_name_ue
  location = var.location_uen
  tags = {
      environment = var.environment
  }
}

# common splunk instances
resource "azurerm_container_group" "common-instances" {
  for_each = var.common_instance
  name                = each.value.name
  location            = azurerm_resource_group.rg_splunk_jp.location
  resource_group_name = azurerm_resource_group.rg_splunk_jp.name
  ip_address_type     = "public"
  dns_name_label      = each.value.name
  os_type             = "linux"

  container {
    name   = var.container_name
    image  = var.docker_image_name
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
    environment = var.environment
  }
}

# create heavy forwarder
resource "azurerm_container_group" "heavyforwarder" {
  name                = var.heavyforwarder
  location            = azurerm_resource_group.rg_splunk_kr.location
  resource_group_name = azurerm_resource_group.rg_splunk_kr.name
  ip_address_type     = "public"
  dns_name_label      = var.heavyforwarder
  os_type             = "linux"

  container {
    name   = var.container_name
    image  = var.docker_image_name
    cpu    = local.idx_cpu
    memory = local.idx_ram
    ports {
      port     = local.webport
      protocol = "TCP"
    }
    ports {
      port     = local.mgmtport
      protocol = "TCP"
    }
    ports {
      port     = local.hecport
      protocol = "TCP"
    }
    ports {
      port     = local.udpport
      protocol = "UDP"
    }
    environment_variables = {
      SPLUNK_START_ARGS        = "--accept-license"
      SPLUNK_PASSWORD          = var.login_password 
    }
  }

  tags = {
    environment = var.environment
  }
}


#create 5 search heads
resource "azurerm_container_group" "shc" {
  for_each = var.searchhead_clustering
  name                = each.value.name
  location            = azurerm_resource_group.rg_splunk_ue.location
  resource_group_name = azurerm_resource_group.rg_splunk_ue.name
  ip_address_type     = "public"
  dns_name_label      = each.value.name
  os_type             = "linux"

  container {
    name   = var.container_name
    image  = var.docker_image_name
    cpu    = local.sh_cpu
    memory = local.sh_ram
    ports {
      port     = local.webport
      protocol = "TCP"
    }
    ports {
      port     = local.mgmtport
      protocol = "TCP"
    }
    ports {
      port     = local.kvport
      protocol = "TCP"
    }
    ports {
      port     = local.replicationport
      protocol = "TCP"
    }
    environment_variables = {
      SPLUNK_START_ARGS        = "--accept-license"
      SPLUNK_PASSWORD          = var.login_password 
    }
  }

  tags = {
    environment = var.environment
  }
}


#create 4 indexers
resource "azurerm_container_group" "idxc" {
  for_each = var.index_clustering
  name                = each.value.name
  location            = azurerm_resource_group.rg_splunk.location
  resource_group_name = azurerm_resource_group.rg_splunk.name
  ip_address_type     = "public"
  dns_name_label      = each.value.name
  os_type             = "linux"

  container {
    name   = var.container_name
    image  = var.docker_image_name
    cpu    = local.idx_cpu
    memory = local.idx_ram
    ports {
      port     = local.webport
      protocol = "TCP"
    }
    ports {
      port     = local.mgmtport
      protocol = "TCP"
    }
    ports {
      port     = local.listenport
      protocol = "TCP"
    }
    ports {
      port     = local.replicationport
      protocol = "TCP"
    }
    environment_variables = {
      SPLUNK_START_ARGS        = "--accept-license"
      SPLUNK_PASSWORD          = var.login_password 
    }
  }

  tags = {
    environment = var.environment
  }
}