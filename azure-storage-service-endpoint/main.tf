# =============================================
# Retrieve Tenant Information
# =============================================
data "azurerm_client_config" "current" {}

# =============================================
# Create Resource Group
# =============================================
resource "azurerm_resource_group" "tnk_rg_name" {
  name     = var.resource_group_name
  location = var.location
}

# =============================================
# Create Virtual Network
# =============================================
resource "azurerm_virtual_network" "tnk_vnet_name" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.tnk_rg_name.name
  address_space       = var.vnet_address_space
}

# =============================================
# Create Management Subnet
# =============================================
resource "azurerm_subnet" "tnk_vnet_subnet" {
  name                 = var.mngment_subnet
  address_prefixes     = var.mngment_subne_address_prefixes
  virtual_network_name = azurerm_virtual_network.tnk_vnet_name.name
  resource_group_name  = azurerm_resource_group.tnk_rg_name.name
  service_endpoints    = ["Microsoft.Storage"]
}

# =============================================
# Create Bastion Subnet
# =============================================
resource "azurerm_subnet" "tnk_bastion_subnet" {
  name                 = var.AzureBastionSubnet
  address_prefixes     = var.bastion_subnet_address_prefixes
  virtual_network_name = azurerm_virtual_network.tnk_vnet_name.name
  resource_group_name  = azurerm_resource_group.tnk_rg_name.name
}

# =============================================
# Create Network Interface for VM
# =============================================
resource "azurerm_network_interface" "tnk_nic" {
  name                = var.network_interface
  location            = var.location
  resource_group_name = azurerm_resource_group.tnk_rg_name.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tnk_vnet_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# =============================================
# Generate Random Password for VM Admin
# =============================================
resource "random_password" "vm_password" {
  length           = 16
  special          = true
  override_special = "!@#$%^&*()_+-=[]{}<>?~"
}

# =============================================
# Create Windows Virtual Machine
# =============================================
resource "azurerm_windows_virtual_machine" "tnk_vm_name" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.tnk_rg_name.name
  size                  = "Standard_F2"
  network_interface_ids = [azurerm_network_interface.tnk_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  admin_username = var.vm_username
  admin_password = random_password.vm_password.result
}

# =============================================
# Create Key Vault
# =============================================
resource "azurerm_key_vault" "tnk_kv" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.tnk_rg_name.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  sku_name                    = "standard"
}

# =============================================
# Create Key Vault Access Policy
# =============================================
resource "azurerm_key_vault_access_policy" "tnk_ap" {
  key_vault_id = azurerm_key_vault.tnk_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
  ]

  storage_permissions = [
    "Get",
  ]

  depends_on = [azurerm_key_vault.tnk_kv]
}

# =============================================
# Store VM Admin Password in Key Vault
# =============================================
resource "azurerm_key_vault_secret" "tnk_vm_password" {
  name         = "${var.vm_name}-password"
  value        = random_password.vm_password.result
  key_vault_id = azurerm_key_vault.tnk_kv.id

  depends_on = [
    azurerm_key_vault.tnk_kv,
    azurerm_key_vault_access_policy.tnk_ap
  ]
}

# =============================================
# Create Public IP for Bastion
# =============================================
resource "azurerm_public_ip" "tnk_pip_name" {
  name                = var.bastion_pip
  location            = var.location
  resource_group_name = azurerm_resource_group.tnk_rg_name.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# =============================================
# Create Bastion Host
# =============================================
resource "azurerm_bastion_host" "tnk_bastion_name" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = azurerm_resource_group.tnk_rg_name.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.tnk_bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.tnk_pip_name.id
  }

  depends_on = [
    azurerm_public_ip.tnk_pip_name,
    azurerm_subnet.tnk_bastion_subnet
  ]
}

# =============================================
# Storage Account
# =============================================
resource "azurerm_storage_account" "tnk_str" {
  name                     = var.storageaccountname
  resource_group_name      = azurerm_resource_group.tnk_rg_name.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.tnk_vnet_subnet.id]
  }

  depends_on = [azurerm_subnet.tnk_vnet_subnet]
}
