

module "bastion" {
  for_each          = module.networking.public_subnets_id
  source            = "github.com/jetbrains-infra/terraform-aws-bastion-host"
  subnet_id         = each.key
  ssh_key           = var.bastion_key_pair
  internal_networks = module.networking.private_subnets_id[each.key.index]
  project           = "myProject"
}