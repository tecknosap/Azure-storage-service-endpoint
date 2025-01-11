# Azure Storage Service Endpoint with Terraform

This project demonstrates how to securely deploy and manage Azure infrastructure using **Terraform**, with a focus on **Azure Storage Service Endpoints**. The setup includes a **Virtual Network (VNet)**, **Windows Virtual Machine (VM)**, **Key Vault**, **Bastion Host**, and a **Storage Account**, all designed with security best practices in mind.

## Architecture Overview

This solution provisions the following key Azure resources:

1. **Azure Resource Group**: Logical container for all Azure resources.
2. **Azure Virtual Network (VNet)**: Secure, isolated network for hosting resources.
3. **Subnets**: 
   - **Management Subnet**: Used for securely managing resources.
   - **Bastion Subnet**: Hosts the Bastion service for RDP/SSH access to VMs without exposing them to the internet.
4. **Windows Virtual Machine**: A Windows Server VM for management purposes, connected securely to the VNet.
5. **Azure Key Vault**: Securely stores sensitive information (e.g., passwords, secrets).
6. **Azure Bastion**: A fully managed service for secure, private RDP/SSH connectivity to VMs.
7. **Azure Storage Account**: A scalable and secure storage solution with restricted access via service endpoints.
8. **Service Endpoint**: Configures storage access to be restricted to the VNet for enhanced security.

## Key Features

- **Secure Access**: Utilizes **Bastion Host** for secure access to VMs without exposing them to the public internet.
- **Service Endpoint Protection**: Ensures Azure Storage Account is accessible only from within the Virtual Network, enhancing data security.
- **Key Vault Integration**: Securely stores and manages VM admin credentials, ensuring sensitive information is never exposed in code.
- **Infrastructure as Code (IaC)**: Managed using **Terraform** to provision and configure all resources in a repeatable, version-controlled manner.

## Prerequisites

Before you begin, make sure you have:

1. **Azure Account**: [Sign up for a free Azure account](https://azure.microsoft.com/en-us/free/).
2. **Terraform**: Install Terraform from [here](https://www.terraform.io/downloads.html).
3. **Azure CLI**: Install the Azure CLI from [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

## Deployment Steps

1. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
Initialize Terraform:

terraform init

Plan the Deployment:

terraform plan

Apply the Configuration:

terraform apply

Verify the Resources: Check the Azure Portal to confirm that the resources (VNet, VM, Storage Account, Key Vault, etc.) were successfully created.

Clean Up: To delete all resources, use:

terraform destroy

Security Considerations:

Private Access to Storage: 

The Storage Account is configured with a service endpoint, limiting access to only the VNet to ensure private, secure communication with the storage services.
No Public Exposure: The VM and storage are protected from public internet exposure by using Azure Bastion for secure remote access and configuring the storage account to only allow connections from the VNet.
Key Vault for Secret Management: The VM admin password is stored securely in Azure Key Vault, ensuring that sensitive credentials are not exposed in the code or elsewhere.

Conclusion:

This setup automates the deployment of a secure Azure environment using Terraform, integrating best practices for network isolation, secure access, and secret management. By leveraging Azure Bastion, Key Vault, and Service Endpoints, this solution ensures a high level of security and operational efficiency.

License
This project is licensed under the MIT License - see the LICENSE file for details.

Feel free to modify the configuration to suit your specific requirements, such as changing the VM size, region, or storage replication options.

Happy Terraforming! 🚀
