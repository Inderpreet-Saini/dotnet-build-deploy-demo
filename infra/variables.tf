variable "common_prefix" {
    description = "Common prefix for each resource name"
    type = string
    default = "dotnet-demo"
}

variable "vpc_id" {
  description = "AWS VPC for deployment"
  type        = string
  default = "vpc-05ecf88a89ac1d3cb"
}

variable "public_ec2_key" {
  description = "Public key for EC2 instances in ECS cluster"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# variable "ecr_namespace" {
#   description = "ECR repo namespace"
#   type        = string
#   default     = "ips"
# }

# variable "ecr_service_name" {
#   description = " ECR repo name"
#   type        = string
#   default     = "dotnet-demo"

# }

variable "ecr_image_repo" {
  type = string
  description = "ECR repo URL"
}

variable "ecr_force_delete" {
    type = bool
    description = "Set to true only if need to allow deletion of ECR repo even if it contains images"
    default = false
}

variable "autoscaling_max_size" {
    type = number
    default = 2
    description = "Maximum instances that can be launched in the ASG"
}

variable "autoscaling_min_size" {
    type = number
    default = 1
    description = "Minimum instances that can be launched in the ASG"
}

variable "container_name" {
  type = string
  default = "app"
  description = "Name of container to be deployed"
}

variable "container_port" {
  type = number
  default = 80
  description = "Port of container to be deployed"
}

variable "image_tag" {
    type = string
    description = "Image tag that needs to be updated to task definition"
}

 variable "ecs_task_desired_count" {
    type = number
    default = 1
    description ="Desired number of replicas of the container"
 }
 variable "ecs_task_deployment_minimum_healthy_percent" {
    type = number
    default = 100
    description ="Minimum % of replicas that need to be always running"
 }
 variable "ecs_task_deployment_maximum_percent" {
    type = number
    default = 200
    description ="Maximum % of replicas that can run at any given time"
 }

 variable "maximum_scaling_step_size" {
   type = number
    default = 2
    description ="Maximum number of instances that can be scaled out at once"
 }

 variable "minimum_scaling_step_size" {
    type = number
    default = 1
    description ="Minimum number of instances that must be scaled out at once"
 }

 variable "target_capacity" {
   default  = 85
   type = number
   description = "Maximum % capacity that must be utilized on ASG before scale out"
 }