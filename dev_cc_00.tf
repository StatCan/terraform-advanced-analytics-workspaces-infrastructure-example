################
## Development #
################
locals {
  aaw_dev_cc_00_kubernetes_version       = "1.19.13"
  aaw_dev_cc_00_nodes_kubernetes_version = "1.19.13"
}

module "aaw_dev_cc_00" {
  source = "git::https://github.com/StatCan/terraform-azure-statcan-aaw-environment.git?ref=v1.4.7"

  // The naming convention of resources within
  // this environment is:
  //
  //   $app-$env-$region-$num-$type-$purpose
  //
  // The common prefix is $app-$env-$region-$num,
  // which is filled in by these values.
  prefixes = {
    application = "aaw"
    environment = "dev"
    location    = "cc"
    num         = "00"
  }

  # Azure configuration
  azure_region = "Canada Central"
  azure_tags = { }

  azure_availability_zones     = ["1", "2", "3"]
  azure_gpu_availability_zones = ["3"]

  # Networking
  # 10.0.0.0/14

  network_start = {
    first  = 10
    second = 0
  }

  # If you have a DDOS plan, connect it:
  # ddos_protection_plan_id = data.azurerm_network_ddos_protection_plan.ddos_protection.id

  resource_owners = var.administrative_groups

  dns_zone = "aaw-dev.example.ca"

  # Cluster
  infrastructure_authorized_ip_ranges = var.infrastructure_authorized_ip_ranges
  infrastructure_pipeline_subnet_ids  = var.infrastructure_pipeline_subnet_ids
  cluster_authorized_ip_ranges        = var.cluster_authorized_ip_ranges
  kubernetes_version                  = local.aaw_dev_cc_00_kubernetes_version

  system_node_pool_kubernetes_version     = local.aaw_dev_cc_00_nodes_kubernetes_version
  system_node_pool_auto_scaling_min_nodes = 3
  system_node_pool_auto_scaling_max_nodes = 7

  system_general_node_pool_kubernetes_version     = local.aaw_dev_cc_00_nodes_kubernetes_version
  system_general_node_pool_auto_scaling_min_nodes = 0
  system_general_node_pool_auto_scaling_max_nodes = 10

  monitoring_node_pool_kubernetes_version     = local.aaw_dev_cc_00_nodes_kubernetes_version
  monitoring_node_pool_auto_scaling_min_nodes = 0
  monitoring_node_pool_auto_scaling_max_nodes = 3

  storage_node_pool_kubernetes_version     = local.aaw_dev_cc_00_nodes_kubernetes_version
  storage_node_pool_auto_scaling_min_nodes = 0
  storage_node_pool_auto_scaling_max_nodes = 1

  user_unclassified_node_pool_kubernetes_version     = local.aaw_dev_cc_00_nodes_kubernetes_version
  user_unclassified_node_pool_auto_scaling_min_nodes = 0
  user_unclassified_node_pool_auto_scaling_max_nodes = 6

  user_gpu_unclassified_node_pool_kubernetes_version     = local.aaw_dev_cc_00_nodes_kubernetes_version
  user_gpu_unclassified_node_pool_auto_scaling_min_nodes = 0
  user_gpu_unclassified_node_pool_auto_scaling_max_nodes = 3

  user_protected_b_node_pool_kubernetes_version     = local.aaw_dev_cc_00_nodes_kubernetes_version
  user_protected_b_node_pool_auto_scaling_min_nodes = 0
  user_protected_b_node_pool_auto_scaling_max_nodes = 3

  user_gpu_protected_b_node_pool_kubernetes_version     = local.aaw_dev_cc_00_nodes_kubernetes_version
  user_gpu_protected_b_node_pool_auto_scaling_min_nodes = 0
  user_gpu_protected_b_node_pool_auto_scaling_max_nodes = 3

  # The pool's kubernetes version is the same as the regular gpu prob nodepool
  user_gpu_four_protected_b_node_pool_auto_scaling_min_nodes = 0
  user_gpu_four_protected_b_node_pool_auto_scaling_max_nodes = 1

  # Cluster RBAC
  # (defined in locals.tf)
  cluster_users   = local.cluster_users
  cluster_admins  = local.cluster_admins
  cluster_ssh_key = local.cluster_ssh_key

  # Ingress (istio ingress gateways)
  # (note these are manual because there is no simple terraform way to fetch them at this time)
  ingress_general_private_ip       = "10.1.254.4"
  ingress_kubeflow_private_ip      = "10.1.254.5"
  ingress_authenticated_private_ip = "10.1.254.6"
  ingress_protected_b_private_ip   = "10.1.254.8"

}

# Connect DNS records into the public DNS zone
// resource "azurerm_dns_ns_record" "ns_aaw_dev_cc_00" {
//   name                = replace(module.aaw_dev_cc_00.dns_zone, ".${local.parent_dns_zone_name}", "")
//   zone_name           = local.parent_dns_zone_name
//   resource_group_name = local.parent_dns_zone_resource_group_name
//   ttl                 = 300
//
//   records = module.aaw_dev_cc_00.dns_zone_name_servers
// }

# Example peer with another VNET
// resource "azurerm_virtual_network_peering" "aaw_dev_cc_00_hub_other" {
//   name = "${module.aaw_dev_cc_00.prefix}-peer-hub-other"

//   virtual_network_name      = module.aaw_dev_cc_00.hub_virtual_network_name
//   resource_group_name       = module.aaw_dev_cc_00.hub_virtual_network_resource_group_name
//   remote_virtual_network_id = "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.Network/virtualNetworks/XXX"

//   allow_forwarded_traffic = true
//   allow_gateway_transit   = false
//   use_remote_gateways     = false
// }

// resource "azurerm_route" "aaw_dev_cc_00_to_other" {
//   name                   = "other"
//   resource_group_name    = module.aaw_dev_cc_00.firewall_route_table_resource_group_name
//   route_table_name       = module.aaw_dev_cc_00.firewall_route_table_name
//   address_prefix         = "192.0.2.0/24"
//   next_hop_type          = "VirtualAppliance"
//   next_hop_in_ip_address = "198.51.100.4"
// }

// resource "azurerm_firewall_policy_rule_collection_group" "aaw_dev_cc_00_other" {
//   name               = "fwprcg-other"
//   firewall_policy_id = module.aaw_dev_cc_00.firewall_policy_id

//   priority = 500

//   network_rule_collection {
//     name     = "other"
//     priority = 500
//     action   = "Allow"

//     rule {
//       name                  = "other-to-load-balancers"
//       source_addresses      = ["192.0.2.0/24"]
//       destination_addresses = module.aaw_dev_cc_00.aks_load_balancers_address_space
//       destination_ports     = ["80", "443"]
//       protocols             = ["TCP"]
//     }
//   }
// }


###
## KUBERNETES
###

provider "kubernetes" {
  alias = "kubernetes_aaw_dev_cc_00"

  host                   = module.aaw_dev_cc_00.kubeconfig.0.host
  username               = module.aaw_dev_cc_00.kubeconfig.0.username
  password               = module.aaw_dev_cc_00.kubeconfig.0.password
  client_certificate     = base64decode(module.aaw_dev_cc_00.kubeconfig.0.client_certificate)
  client_key             = base64decode(module.aaw_dev_cc_00.kubeconfig.0.client_key)
  cluster_ca_certificate = base64decode(module.aaw_dev_cc_00.kubeconfig.0.cluster_ca_certificate)
}

provider "helm" {
  alias = "helm_aaw_dev_cc_00"

  kubernetes {
    host                   = module.aaw_dev_cc_00.kubeconfig.0.host
    username               = module.aaw_dev_cc_00.kubeconfig.0.username
    password               = module.aaw_dev_cc_00.kubeconfig.0.password
    client_certificate     = base64decode(module.aaw_dev_cc_00.kubeconfig.0.client_certificate)
    client_key             = base64decode(module.aaw_dev_cc_00.kubeconfig.0.client_key)
    cluster_ca_certificate = base64decode(module.aaw_dev_cc_00.kubeconfig.0.cluster_ca_certificate)
  }
}

# Connect DNS records into the public DNS zone
// resource "azurerm_dns_ns_record" "ns" {
//   name                = replace(module.aaw_dev_cc_00.dns_zone, ".${local.parent_dns_zone_name}", "")
//   zone_name           = local.parent_dns_zone_name
//   resource_group_name = local.parent_dns_zone_resource_group_name
//   ttl                 = 300

//   records = module.aaw_dev_cc_00.dns_zone_name_servers
// }

module "aaw_dev_cc_00_platform" {
  providers = {
    kubernetes = kubernetes.kubernetes_aaw_dev_cc_00
    helm       = helm.helm_aaw_dev_cc_00
  }

  source = "git::https://github.com/StatCan/terraform-statcan-aaw-platform.git?ref=v2.2.3"

  prefix       = module.aaw_dev_cc_00.prefix
  azure_region = module.aaw_dev_cc_00.azure_region
  azure_tags   = module.aaw_dev_cc_00.azure_tags

  subscription_id = data.azurerm_client_config.current.subscription_id
  tenant_id       = data.azurerm_client_config.current.tenant_id

  infrastructure_pipeline_subnet_ids = var.infrastructure_pipeline_subnet_ids

  cluster_resource_group_name      = module.aaw_dev_cc_00.cluster_resource_group_name
  cluster_node_resource_group_name = module.aaw_dev_cc_00.cluster_node_resource_group
  kubernetes_identity_object_id    = module.aaw_dev_cc_00.kubernetes_identity_object_id
  aks_system_subnet_id             = module.aaw_dev_cc_00.aks_system_subnet_id

  dns_zone_name                = module.aaw_dev_cc_00.dns_zone
  dns_zone_id                  = module.aaw_dev_cc_00.dns_zone_id
  dns_zone_resource_group_name = module.aaw_dev_cc_00.dns_zone_resource_group_name
  dns_zone_subscription_id     = module.aaw_dev_cc_00.dns_zone_subscription_id

  # kubecost
  kubecost_cluster_profile          = "development"
  kubecost_token                    = var.kubecost_token
  kubecost_client_id                = var.kubecost_client_id
  kubecost_client_secret            = var.kubecost_client_secret
  kubecost_product_key              = var.kubecost_product_key
  kubecost_prometheus_node_selector = { "topology.kubernetes.io/zone" = "canadacentral-1" }
  kubecost_storage_account          = var.kubecost_storage_account
  kubecost_storage_access_key       = var.kubecost_storage_access_key
  kubecost_storage_container        = var.kubecost_storage_container
  kubecost_shared_namespaces        = var.kubecost_shared_namespaces
  kubecost_slack_token              = var.kubecost_slack_token

  # vault
  vault_address = "https://vault.${module.aaw_dev_cc_00.dns_zone}"

  administrative_groups = var.administrative_groups

  load_balancer_subnet = module.aaw_dev_cc_00.aks_load_balancers_subnet_name
}
