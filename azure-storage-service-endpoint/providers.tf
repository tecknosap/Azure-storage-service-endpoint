# =============================================
# Terraform Required Providers
# =============================================

terraform {
  required_providers {
    # Azure Resource Manager Provider (azurerm)
    azurerm = {
      source = "hashicorp/azurerm"  # Source of the provider
      version = "4.14.0"            # Version of the provider
    }
  }
}

# =============================================
# Azure Provider Configuration
# =============================================

provider "azurerm" {
  features {}  # Enabling the default features for the provider
}

