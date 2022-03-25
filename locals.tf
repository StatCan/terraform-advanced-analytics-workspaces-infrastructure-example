
data "azurerm_client_config" "current" {}

locals {
  parent_dns_zone_name                = "example.ca"
  parent_dns_zone_resource_group_name = "dns-rg"
}

# RBAC
locals {
  # Users who can access the OIDC-based kubeconfig
  cluster_users = [
    "XXX"
  ]

  # Users who can pull the admin kubeconfig
  cluster_admins = [
    "XXX"
  ]

  # SSH Key for management
  cluster_ssh_key = "SSH_KEY_GOES_HERE"
}
