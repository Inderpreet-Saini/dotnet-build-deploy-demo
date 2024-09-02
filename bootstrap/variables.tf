variable "region" {
    description = "AWS Region"
    type = string
    default = "ap-south-1"
}

variable "github_org" {
    description = "Github Organisation"
    type = string
    default = "Inderpreet-Saini"
}

variable "github_repo" {
    description = "Github Repo"
    type = string
    default = "dotnet-build-deploy-demo"
}

variable "ecr_namespace" {
  description = "ECR repo namespace"
  type        = string
  default     = "ips"
}

variable "ecr_service_name" {
  description = " ECR repo name"
  type        = string
  default     = "dotnet-demo"

}

variable "ecr_force_delete" {
    type = bool
    description = "Set to true only if need to allow deletion of ECR repo even if it contains images"
    default = false
}

variable "app_name" {
 default = "myfavouriteplaces"
 type = string
 description = ".NET Application name that needs to be deployed"
}
