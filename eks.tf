module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.5.0"
  cluster_name    = "project-eks"
  cluster_version = "1.27"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  manage_aws_auth = true

  node_groups = {
    critical = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
      key_name         = var.key_name
      labels = {
        workload = "critical"
      }
      tags = {
        Name = "critical-node"
      }
    }

    app = {
      desired_capacity = 2
      max_capacity     = 4
      min_capacity     = 1
      instance_type    = "t3.small"
      key_name         = var.key_name
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

# Output kubeconfig
output "kubeconfig" {
  value = module.eks.kubeconfig
  description = "Kubeconfig to access EKS cluster"
  sensitive = true
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

