module "vpc" {
  source = "../vpc"
# Limited to 2 AZ in this case due to External IP  needed in the code
  az_asg = ["eu-west-1a", "eu-west-1b"]
  module_suffix = "_eks_module"
    ingress_rules =  {
      tls_from_vpc = {
        description      = "SSH to the box"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
      }
      http_from_anywhere = {
      description = "HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      }
      # Add more ingress rules as needed
    }
}


module "eks_cluster" {
  source              = "terraform-aws-modules/eks/aws"
  version = "19.16.0"
  cluster_name        = "cluster_${terraform.workspace}"
  cluster_version     = "1.28"  # Choose the desired Kubernetes version
  subnet_ids          = module.vpc.subnet_id_private
  vpc_id              = module.vpc.vpc_id
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
#  manage_aws_auth_configmap = true

#  aws_auth_roles = [
#    {
#      rolearn  = aws_iam_role.k8s_role.arn
#      username = "role1"
#      groups   = ["system:masters"]
#    },
#    {
#      rolearn  = aws_iam_role.node_role.arn
#      username = "role2"
#      groups   = ["system:masters"]
#    }
#  ]
  kms_key_aliases = ["test1"]
#  create_iam_role = false
  iam_role_permissions_boundary = var.permission_boundary
  fargate_profiles = {
    coredns-fargate-profile = {
      name = "coredns"
      iam_role_permissions_boundary = var.permission_boundary
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        },
        {
          namespace = "default"
        }
      ]
      subnets = concat(module.vpc.subnet_id_public, module.vpc.subnet_id_private)
    }
  }
#  eks_managed_node_group_defaults = {
#    disk_size = 20
#  }
#  eks_managed_node_groups = {
#    general = {
#      desired_size = 1
#      min_size     = 1
#      max_size     = 1
#
#      labels = {
#        role = "general"
#      }
#
#      instance_types = ["t3.small"]
#      capacity_type  = "ON_DEMAND"
#    }
#
#    spot = {
#      desired_size = 1
#      min_size     = 1
#      max_size     = 1
#
#      labels = {
#        role = "spot"
#      }
#
#      taints = [{
#        key    = "market"
#        value  = "spot"
#        effect = "NO_SCHEDULE"
#      }]
#
#      instance_types = ["t3.micro"]
#      capacity_type  = "SPOT"
#    }
#  }

  tags = {
    Environment = "staging"
  }
}


#module "eks_managed_node_group" {
#  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
#  name            = "node_${terraform.workspace}"
#  cluster_name    = module.eks_cluster.cluster_name
#  iam_role_permissions_boundary = var.permission_boundary
#  subnet_ids = concat(module.vpc.subnet_id_public, module.vpc.subnet_id_private)
#
#  // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
#  // Without it, the security groups of the nodes are empty and thus won't join the cluster.
#  cluster_primary_security_group_id = module.eks_cluster.cluster_primary_security_group_id
#  min_size     = 1
#  max_size     = 2
#  desired_size = 1
#
#  instance_types = ["t3.large"]
#  capacity_type  = "SPOT"
#
#  labels = {
#    Environment = "test"
#    GithubRepo  = "terraform-aws-eks"
#    GithubOrg   = "terraform-aws-modules"
#  }
#
#  taints = {
#    dedicated = {
#      key    = "dedicated"
#      value  = "gpuGroup"
#      effect = "NO_SCHEDULE"
#    }
#  }
#
#  tags = {
#    Environment = "dev"
#    Terraform   = "true"
#  }
#}

module "fargate_profile" {
  source = "terraform-aws-modules/eks/aws//modules/fargate-profile"
  name            = "fargate_${terraform.workspace}"
  cluster_name    = module.eks_cluster.cluster_name
  iam_role_permissions_boundary = var.permission_boundary
  subnet_ids = concat(module.vpc.subnet_id_public, module.vpc.subnet_id_private)
  selectors = [{
    namespace = "default"
  }]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

#resource "aws_eks_addon" "coredns" {
#  addon_name        = "coredns"
#  cluster_name      = "cluster_doug"
#  resolve_conflicts = "OVERWRITE"
#  depends_on        = [module.eks_cluster]
#}