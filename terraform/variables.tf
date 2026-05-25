variable "vpc_name" {
  default     = "jerney-vpc"
  description = "Vpc Name"
  type        = string

}

variable "vpc_cidr_range" {
  default = "10.0.0.0/16"
}

variable "vpc_az" {
  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}

variable "vpc_private_subnet" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  type = list(string)

}

variable "vpc_public_subnet" {
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  type = list(string)
}

variable "eks_cluster_name" {
  default = "jerney-eks-cluster"
}

variable "eks_nodegroup_instance_type" {
  default = "t3.small"
}

variable "eks_nodegroup_min_size" {
  default = 1
}

variable "eks_nodegroup_max_size" {
  default = 2
}

variable "eks_nodegroup_desired_size" {
  default = 2
}

variable "tag_environment" {
  default = "dev"
}