output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = module.networking.public_subnets_id
}

output "private_subnets_id" {
  value = module.networking.private_subnets_id
}
