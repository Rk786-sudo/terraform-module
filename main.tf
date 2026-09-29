locals {
  public_endpoint_enabled  = contains(["public", "both"], var.eks_endpoint_access)
  private_endpoint_enabled = contains(["private", "both"], var.eks_endpoint_access)
  common_tags              = var.resource_tags
}

module "vpc" {
  source = "./modules/vpc"

  name       = var.cluster_name
  cidr_block = var.vpc_cidr
  tags       = local.common_tags
}

module "subnets" {
  source = "./modules/subnets"

  name                  = var.cluster_name
  vpc_id                = module.vpc.vpc_id
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  tags                  = local.common_tags
}

module "internet_gateway" {
  source = "./modules/internet-gateway"

  name   = var.cluster_name
  vpc_id = module.vpc.vpc_id
  tags   = local.common_tags
}

module "nat_gateway" {
  source = "./modules/nat-gateway"

  name              = var.cluster_name
  enabled           = var.nat_gateway_enabled
  single_nat_gateway = var.single_nat_gateway
  public_subnet_ids = module.subnets.public_subnet_ids
  tags              = local.common_tags

  depends_on = [module.internet_gateway]
}

module "route_tables" {
  source = "./modules/route-tables"

  name                 = var.cluster_name
  vpc_id               = module.vpc.vpc_id
  internet_gateway_id  = module.internet_gateway.internet_gateway_id
  nat_gateway_ids      = module.nat_gateway.nat_gateway_ids
  public_subnet_ids    = module.subnets.public_subnet_ids
  private_subnet_ids   = module.subnets.private_subnet_ids
  single_nat_gateway   = var.single_nat_gateway
  tags                 = local.common_tags
}

module "nacl" {
  source = "./modules/nacl"

  name                    = var.cluster_name
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = var.vpc_cidr
  public_subnet_ids       = module.subnets.public_subnet_ids
  private_subnet_ids      = module.subnets.private_subnet_ids
  public_ingress_rules    = var.public_nacl_ingress_rules
  public_egress_rules     = var.public_nacl_egress_rules
  private_ingress_rules   = var.private_nacl_ingress_rules
  private_egress_rules    = var.private_nacl_egress_rules
  tags                    = local.common_tags
}

module "security_groups" {
  source = "./modules/security-groups"

  name                    = var.cluster_name
  vpc_id                  = module.vpc.vpc_id
  eks_public_access_cidrs = local.public_endpoint_enabled ? var.eks_public_access_cidrs : []
  eks_admin_access_cidrs  = var.eks_admin_access_cidrs
  ssh_enabled             = var.ssh_key_pair_name != null && length(var.ssh_trusted_cidrs) > 0
  ssh_trusted_cidrs       = var.ssh_trusted_cidrs
  tags                    = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  name                  = var.cluster_name
  enable_ebs_csi_driver = var.enable_ebs_csi_driver
  tags                  = local.common_tags
}

module "eks_cluster" {
  source = "./modules/eks-cluster"

  name                       = var.cluster_name
  kubernetes_version         = var.kubernetes_version
  cluster_role_arn           = module.iam.cluster_role_arn
  private_subnet_ids         = module.subnets.private_subnet_ids
  cluster_security_group_id  = module.security_groups.cluster_security_group_id
  endpoint_private_access    = local.private_endpoint_enabled
  endpoint_public_access     = local.public_endpoint_enabled
  public_access_cidrs        = var.eks_public_access_cidrs
  control_plane_log_types    = var.control_plane_log_types
  tags                       = local.common_tags

  depends_on = [module.iam, module.route_tables, module.nacl]
}

module "eks_nodegroup" {
  source = "./modules/eks-nodegroup"

  cluster_name          = module.eks_cluster.cluster_name
  node_group_name       = var.node_group_name
  node_role_arn         = module.iam.node_role_arn
  private_subnet_ids    = module.subnets.private_subnet_ids
  node_security_group_id = module.security_groups.worker_security_group_id
  admin_security_group_id = module.security_groups.admin_security_group_id
  instance_type         = var.worker_instance_type
  desired_size          = var.desired_worker_count
  min_size              = var.minimum_worker_count
  max_size              = var.maximum_worker_count
  disk_size             = var.worker_disk_size
  ami_type              = var.worker_ami_type
  ssh_key_pair_name     = var.ssh_key_pair_name
  ssh_enabled           = var.ssh_key_pair_name != null && length(var.ssh_trusted_cidrs) > 0
  tags                  = local.common_tags

  depends_on = [module.eks_cluster, module.iam]
}

module "eks_addons" {
  source = "./modules/eks-addons"

  cluster_name          = module.eks_cluster.cluster_name
  cluster_version       = var.kubernetes_version
  enable_ebs_csi_driver = var.enable_ebs_csi_driver
  ebs_csi_role_arn      = module.iam.ebs_csi_role_arn
  tags                  = local.common_tags

  depends_on = [module.eks_cluster, module.eks_nodegroup, module.iam]
}