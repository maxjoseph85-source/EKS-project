variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "eks-project"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "Public subnet 1 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "Public subnet 2 CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "Private subnet 1 CIDR"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "Private subnet 2 CIDR"
  type        = string
  default     = "10.0.4.0/24"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "enterprise-cluster"
}

variable "node_group_name" {
  description = "EKS node group name"
  type        = string
  default     = "enterprise-node-group"
}

variable "instance_types" {
  description = "Worker node instance types"
  type        = list(string)
  default     = ["t3.small"]
}

variable "desired_size" {
  description = "Desired node count"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum node count"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum node count"
  type        = number
  default     = 1
}