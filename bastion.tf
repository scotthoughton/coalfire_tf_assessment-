module "bastion" {
  for_each =  [for i in module.networking.private_subnets_id : i.id]
  source            = "github.com/jetbrains-infra/terraform-aws-bastion-host"
  subnet_id         = module.networking.public_subnets_id[index(keys(module.networking.private_subnets_id), each.key)]
  ssh_key           = var.bastion_key_pair
  internal_networks = [each.key]
  project           = "myProject"
}