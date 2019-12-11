# variables.tf
variable "access_key" {
     default = "AKIAWLKHQOHGHLNVIOID"
}
variable "secret_key" {
     default = "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"
}
variable "region" {
     default = "us-west-2"
}
variable "availabilityZone" {
     default = "us-west-2b"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "subnetCIDRblock" {
    default = "10.0.1.0/24"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}

variable "ecs_cluster_name" {
  default     = "Flask"
  description = "ECS Cluster Name"
}

variable "service_name" {
  default     = "flask"
  description = "ECS Service Name"
}

variable "image_tag" {
  type        = string
  default     = "latest"
  description = "Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "aws_account_id" {
  type        = string
  default     = ""
  description = "AWS Account ID. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "image_repo_name" {
  type        = string
  default     = "flask"
  description = "ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html)"
}

variable "build_image" {
  type        = string
  default     = "aws/codebuild/docker:17.09.0"
  description = "Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0`"
}

variable "build_timeout" {
  type        = number
  default     = 60
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed"
}

variable "buildspec" {
  type        = string
  default     = "buildspec.yaml"
  description = "Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)"
}


variable "repo_name" {
  default     =  "Flask"
  description = "GitHub repository name of the application to be built and deployed to ECS"
}

variable "branch" {
  default     = "master"
  description = "Branch of the GitHub repository, _e.g._ `master`"
}

variable "name" {
  default     = "flask"
  description = "Name of the application"
}


variable "repo" {
  default     = "https://git-codecommit.ap-south-1.amazonaws.com/v1/repos/flaskappz"
}


variable "tags" {
  default     = "latest"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Enable `CodePipeline` creation"
}

variable "github_repository" {
  default     = "flask"
}

variable "codebuild_compute_type" {
  description = "Compute resources used by the build"
  default     = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
  description = "Base image for provisioning"
  default     = "aws/codebuild/ubuntu-base:14.04"

}

variable "codebuild_privileged_mode" {
  description = "Enables running the Docker daemon inside a Docker container"
  default     = "false"
}


variable "codebuild_environment_variables" {
  description = "Environment variables to be used for build"
  default     = []
  }

variable "codebuild_bucket" {
  description = "S3 bucket to store status badge and artifacts"
  default     = "codepipeline-ap-south-1-780750489574"
}
