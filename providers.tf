terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.5.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "=2.3.0"
    }
  }
}

provider "azurerm" {
  # skip_provider_registration   = true
  disable_terraform_partner_id = true

  features {}
}
