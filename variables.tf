variable "infrastructure_authorized_ip_ranges" {
  type        = list(string)
  description = "Allowed IP addresses for infastructure components."

  default = []
}

variable "infrastructure_pipeline_subnet_ids" {
  type        = list(string)
  description = "Subnet ID of infrastructure pipeline"

  default = []
}

variable "cluster_authorized_ip_ranges" {
  type        = list(string)
  description = "Authorized IP ranges for connecting to the API server."

  default = []
}

variable "administrative_groups" {
  type        = list(string)
  description = "List of administrative groups"
}

# KubeCost

variable "kubecost_token" {

}

variable "kubecost_client_id" {

}

variable "kubecost_client_secret" {

}

variable "kubecost_product_key" {

}

variable "kubecost_storage_account" {

}

variable "kubecost_storage_access_key" {

}

variable "kubecost_storage_container" {

}

variable "kubecost_shared_namespaces" {

}

variable "kubecost_slack_token" {

}
