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
  subnets             = module.vpc.subnet_id_private
  vpc_id              = module.vpc.vpc_id
  cluster_endpoint_private_access = true
  worker_groups = [
    {
      instance_type = "t2.micro"  # Specify the desired instance type for your worker nodes
      asg_max_size  = 1
      asg_min_size  = 1
    },
    # Add more worker group configurations as needed
  ]

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}