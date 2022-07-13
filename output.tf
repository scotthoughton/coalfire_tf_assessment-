output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnets_id" {
  value = module.networking.public_subnets_id
}

output "private_subnets_id" {
  value = module.networking.private_subnets_id
}
output "elb_dns_name" {
  value       = aws_elb.cf-assessment.dns_name
  description = "The domain name of the load balancer"
}