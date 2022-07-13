

module "bastion" {
  count             = length([module.networking.public_subnets_id])
  source            = "github.com/jetbrains-infra/terraform-aws-bastion-host"
  subnet_id         = module.networking.public_subnets_id[count.index]
  ssh_key           = var.bastion_key_pair
  internal_networks = module.networking.private_subnets_id[count.index]
  project           = "myProject"
}