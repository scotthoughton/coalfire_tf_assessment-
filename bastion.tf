locals {
  networks = flatten([
    for private_network_key, private_network in module.networking.private_subnets_id : [
      for public_network_key, public_network in module.networking.public_subnets_id : {
        private_network_key = private_network_key
        public_network_key = public_network_key
      }
    ]
  ])
}

module "bastion" {
  for_each          = {
    for network in local.networks : "${public_network_key.private_network_key}.${public_network_key.public_network_key}" => network
  } 
  source            = "github.com/jetbrains-infra/terraform-aws-bastion-host"
  subnet_id         = module.networking.public_subnets_id[each.key.private_network_key]
  ssh_key           = var.bastion_key_pair
  internal_networks = module.networking.private_subnets_id[each.key.private_network_key]
  project           = "myProject"
}