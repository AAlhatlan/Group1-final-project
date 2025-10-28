prefix              = "grp1"
location            = "austriaeast"
resource_group_name = "rg-group1-austriaeast"

aks_node_count = 2
aks_vm_size    = "Standard_B2s"
aks_min_count  = 2
aks_max_count  = 3

sql_admin    = "sqladmin"
sql_password = "MyStrongP@ssword123"

key_vault_name_suffix = "keyvault"
key_vault_sku_name    = "standard"

key_vault_purge_protection_enabled      = true
key_vault_public_network_access_enabled = true
key_vault_enabled_for_deployment        = true
key_vault_enabled_for_template_deployment = false
key_vault_enabled_for_disk_encryption     = false

key_vault_access_policies = [
  {
    tenant_id          = "84f58ce9-43c8-4932-b908-591a8a3007d3"
    object_id          = "42d57fb4-0c8f-442b-bcc8-d547c8513d5f"
    secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Purge"]
    key_permissions    = ["Get", "List"]
    certificate_permissions = ["Get", "List"]
    storage_permissions     = []
  }
]

key_vault_tags = {
  Environment = "Production"
  Project     = "grp1"
}
