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

resource "aws_eks_cluster" "k8s_training" {
  name     = "cluster_${terraform.workspace}_k8s${var.module_suffix}"
  role_arn = aws_iam_role.k8s_role.arn

  vpc_config {
    subnet_ids = [module.vpc.subnet_id_private[1], module.vpc.subnet_id_private[0]]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [ aws_iam_policy.k8s_policy ]
}

resource "aws_eks_node_group" "k8s_training_node_group" {
  cluster_name    = aws_eks_cluster.k8s_training.name
  node_group_name = "nodegroup_${terraform.workspace}_k8s${var.module_suffix}"
  node_role_arn   = aws_iam_role.k8s_role.arn
  subnet_ids      = module.vpc.subnet_id_private[0]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

#  lifecycle {
#    ignore_changes = [scaling_config[0].desired_size]
#  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_policy.k8s_policy
  ]
}