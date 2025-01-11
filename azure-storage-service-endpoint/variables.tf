# =============================================
# Global Variables
# =============================================

# Resource Group Name
variable "resource_group_name" {
  description = "Global Resource Group"
  type        = string
  default     = "rg-tnk-dev-01"
}

# Location for all resources
variable "location" {
  description = "Global Location"
  type        = string
  default     = "Canada Central"
}

# =============================================
# Virtual Network Variables
# =============================================

# Virtual Network Name
variable "vnet_name" {
  description = "Global Location"
  type        = string
  default     = "vnet-de-tnk-01"
}

# Address space for the Virtual Network
variable "vnet_address_space" {
  description = "Address space for the Virtual Machine VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

# =============================================
# Subnet Variables
# =============================================

# Management Subnet Name
variable "mngment_subnet" {
  description = "Management subnet"
  type        = string
  default     = "snet-shared-canadacentral-01"
}

# Management Subnet Address Prefixes
variable "mngment_subne_address_prefixes" {
  description = "Management subnet address prefixes"
  type        = list(string)
  default     = ["10.1.0.0/24"]
}

# Azure Bastion Subnet Name
variable "AzureBastionSubnet" {
  description = "Bastion subnet"
  type        = string
  default     = "AzureBastionSubnet"
}

# Bastion Subnet Address Prefixes
variable "bastion_subnet_address_prefixes" {
  description = "Address prefixes for the Bastion subnet"
  type        = list(string)
  default     = ["10.1.1.0/27"]
}

# =============================================
# Virtual Machine Variables
# =============================================

# Virtual Machine Name
variable "vm_name" {
  description = "Virtual machine name"
  type        = string
  default     = "vm-tnk-dev-01"
}

# Virtual Machine Admin Username
variable "vm_username" {
  description = "Virtual Machine admin username"
  type        = string
  default     = "teckno"
}

# Network Interface Name for Virtual Machine
variable "network_interface" {
  description = "Virtual Machine network interface"
  type        = string
  default     = "Nic11"
}

# =============================================
# Azure Bastion Host Variables
# =============================================

# Bastion Host Name
variable "bastion_name" {
  description = "Bastion name"
  type        = string
  default     = "bastion-tnk-dev-01"
}

# Bastion Public IP Name
variable "bastion_pip" {
  description = "Name for the Bastion public IP"
  type        = string
  default     = "pip-tnk-dev-01"
}

# =============================================
# Key Vault Variables
# =============================================

# Key Vault Name
variable "key_vault_name" {
  description = "Key Vault Name"
  type        = string
  default     = "kv-tnk-dev-01"
}

variable "storageaccountname" {
  description = "Storage account name"
  type        = string
  default     = "tnkstrdev"
}

