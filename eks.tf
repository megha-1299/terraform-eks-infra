module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.0"

  cluster_name    = "project-eks"
  cluster_version = "1.27"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  manage_aws_auth = true

  eks_managed_node_groups = {
    critical = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
      key_name       = var.key_name
      labels = {
        workload = "critical"
      }
      tags = {
        Name = "critical-node"
      }
    }

    app = {
      desired_size   = 2
      max_size       = 4
      min_size       = 1
      instance_types = ["t3.small"]
      key_name       = var.key_name
      labels = {
        workload = "app"
      }
      tags = {
        Name = "app-node"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
