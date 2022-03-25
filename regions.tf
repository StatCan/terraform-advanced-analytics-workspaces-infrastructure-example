module "aaw_common_cc" {
  source = "git::https://github.com/StatCan/terraform-azure-statcan-aaw-region-environment.git?ref=v2.0.0"

  // The naming convention of resources within
  // this environment is:
  //
  //   $app-$env-$region-$num-$type-$purpose
  //
  // The common prefix is $app-$env-$region-$num,
  // which is filled in by these values.
  prefixes = {
    application = "aaw"
    environment = "common"
    location    = "cc"
  }

  # Azure configuration
  azure_region = "Canada Central"
  azure_tags = { }
}
