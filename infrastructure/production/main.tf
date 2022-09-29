provider "aws" {
    region  = var.aws_region
    profile = var.aws_profile
}

module "ecr" {
    source = "../modules/ecr"

    project_name = var.project_name
    environment = var.environment
    aws_region  = var.aws_region
}

module "route53" {
    source = "../modules/route53"

    domain = var.domain
    lb_dns_name = module.load-balancer.output_lb_dns_name
    lb_zone_id = module.load-balancer.output_lb_zone_id
}

module "vpc" {
    source = "../modules/vpc"

    project_name = var.project_name
    environment = var.environment
    aws_profile = var.aws_profile
    aws_region  = var.aws_region
}

module "load-balancer" {
    source = "../modules/load-balancer"

    project_name = var.project_name
    environment = var.environment
    vpc_id      = module.vpc.output_vpc_id
    subnet_1_id = module.vpc.output_public_subnet_1_id
    subnet_2_id = module.vpc.output_public_subnet_2_id
    app_port = var.app_port
    ssl_certificate_arn = module.route53.output_ssl_certificate_arn
    depends_on = [
      module.ecr,
      module.vpc
    ]
}

module "ecs" {
    source = "../modules/ecs"

    project_name = var.project_name
    environment = var.environment
    ecr_image = module.ecr.output_ecr_image_url
    app_port = var.app_port
    lb_target_group_arn = module.load-balancer.output_lb_target_group_arn
    lb_security_group_id = module.load-balancer.output_lb_security_group_id
    vpc_id      = module.vpc.output_vpc_id
    subnet_1_id = module.vpc.output_private_subnet_1_id
    subnet_2_id = module.vpc.output_private_subnet_2_id
    depends_on = [
      module.ecr,
      module.load-balancer,
      module.vpc,
    ]
}



