module "vpc" {
  source = "../vpc"
# Limited to 2 AZ in this case due to External IP  needed in the code
  az_asg = ["eu-west-1a", "eu-west-1b"]
  module_suffix = "_asg_module"
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
  cluster_name        = "cluster_${terraform.workspace}_k8s${var.module_suffix}"
  cluster_version     = "1.28"  # Choose the desired Kubernetes version
  subnet_ids          = module.vpc.subnet_id_private
  vpc_id              = module.vpc.vpc_id
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  eks_managed_node_group_defaults = {
    disk_size = 20
  }
  eks_managed_node_groups = {
    general = {
      desired_size = 1
      min_size     = 1
      max_size     = 1

      labels = {
        role = "general"
      }

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }

    spot = {
      desired_size = 1
      min_size     = 1
      max_size     = 1

      labels = {
        role = "spot"
      }

      taints = [{
        key    = "market"
        value  = "spot"
        effect = "NO_SCHEDULE"
      }]

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "staging"
  }
}