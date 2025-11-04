variable "cluster_name" {
    description = " Kubernetes Cluster Name"
    default = "otel_eks"
}
variable "cluster_version" {
   description = "Kubernetes version"
   type = string
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "subnet_ids" {
  description = "Subnet ID"
  type = list(string)
}

variable "node_groups" {
  description = "EKS node group configuration"
  type = map(object( {
    instance_types = list(string)
    capacity_type = string
    scaling_config = object( {
    min_size = number
    max_size = number
    desired_size = number
  })
  }))
}

