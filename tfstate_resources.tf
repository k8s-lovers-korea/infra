// Terraform resources to host remote state in Azure Blob Storage.
// Workflow:
// 1) Run `terraform init` (local backend) and `terraform apply` to create these resources.
// 2) Re-run `terraform init -backend-config=...` (see backend-example.tf) to configure the azurerm backend and migrate state.

resource "azurerm_resource_group" "tfstate" {
  name     = "${var.prefix}-tfstate-rg"
  location = var.location
}

resource "azurerm_storage_account" "tfstate" {
  name                     = substr(lower("${var.prefix}tfstate"), 0, 24)
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  allow_blob_public_access = false

  blob_properties {
    versioning_enabled = true
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "tfstate_sa_blob" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
