terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.79"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_kuma" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa_kuma" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg_kuma.name
  location                 = azurerm_resource_group.rg_kuma.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_share" "share_kuma" {
  name                 = "kumashare"
  storage_account_name = azurerm_storage_account.sa_kuma.name
  quota                = var.storage_quota
  access_tier          = "Hot"
}

resource "azurerm_service_plan" "service_plan_kuma" {
  name                = "service-plan-kuma"
  resource_group_name = azurerm_resource_group.rg_kuma.name
  location            = azurerm_resource_group.rg_kuma.location
  os_type             = "Linux"
  sku_name            = var.service_plan_sku
}

resource "azurerm_linux_web_app" "web_app_kuma" {
  name                = var.web_app_name
  resource_group_name = azurerm_resource_group.rg_kuma.name
  location            = azurerm_resource_group.rg_kuma.location
  service_plan_id     = azurerm_service_plan.service_plan_kuma.id
  https_only          = true

  site_config {
    http2_enabled       = true
    minimum_tls_version = "1.2"

    application_stack {
      docker_image_name   = var.docker_image
      docker_registry_url = "https://index.docker.io"
    }
  }

  storage_account {
    access_key   = azurerm_storage_account.sa_kuma.primary_access_key
    account_name = azurerm_storage_account.sa_kuma.name
    name         = "webappstorage"
    type         = "AzureFiles"
    share_name   = azurerm_storage_share.share_kuma.name
    mount_path   = "/app/data"
  }
}
