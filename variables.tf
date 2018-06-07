// Variables specific to module label
variable "attributes" {
  description = "Suffix name with additional attributes (policy, role, etc.)"
  type        = "list"
  default     = []
}

variable "delimiter" {
  description = "Delimiter to be used between `name`, `namespaces`, `attributes`, etc."
  default     = "-"
}

variable "environment" {
  description = "Environment (ex: `dev`, `qa`, `stage`, `prod`). (Second or top level namespace. Depending on namespacing options)"
}

variable "name" {
  description = "Base name for resources"
}

variable "namespace-env" {
  description = "Prefix name with the environment. If true, format is: <env>-<name>"
  default     = true
}

variable "namespace-org" {
  description = "Prefix name with the organization. If true, format is: <org>-<env namespaced name>. If both env and org namespaces are used, format will be <org>-<env>-<name>"
  default     = false
}

variable "organization" {
  description = "Organization name (Top level namespace)."
  default     = ""
}

variable "tags" {
  description = "A map of additional tags"
  type        = "map"
  default     = {}
}

// Variables specific to this module
variable "enabled" {
  description = "Set to false to prevent the module from creating anything"
  default     = true
}

variable "additional_user_data_script" {
  description = ""
  default     = ""
}

variable "allowed_cidr_blocks" {
  description = "List of subnets to allow into the ECS Security Group. Defaults to ['0.0.0.0/0']"
  default     = ["0.0.0.0/0"]
  type        = "list"
}

variable "ami" {
  description = ""
  default     = ""
}

variable "ami_version" {
  description = ""
  default     = "*"
}

variable "associate_public_ip_address" {
  description = ""
  default     = false
}

variable "docker_storage_size" {
  description = "EBS Volume size in Gib that the ECS Instance uses for Docker images and metadata "
  default     = "22"
}

variable "dockerhub_email" {
  description = "Email Address used to authenticate to dockerhub. http://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html"
  default     = ""
}

variable "dockerhub_token" {
  description = "Auth Token used for dockerhub. http://docs.aws.amazon.com/AmazonECS/latest/developerguide/private-auth.html"
  default     = ""
}

variable "ebs_optimized" {
  description = "EBS Optimized"
  default     = true
}

variable "extra_tags" {
  description = ""
  default     = []
}

variable "heartbeat_timeout" {
  description = "Heartbeat Timeout setting for how long it takes for the graceful shutodwn hook takes to timeout. This is useful when deploying clustered applications like consul that benifit from having a deploy between autoscaling create/destroy actions. Defaults to 180"
  default     = "180"
}

variable "iam_path" {
  description = "IAM path, this is useful when creating resources with the same name across multiple regions. Defaults to /"
  default     = "/"
}

variable "custom_iam_policy" {
  description = "Custom IAM policy (JSON). If set will overwrite the default one"
  default     = ""
}

variable "instance_type" {
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
  default     = "m5.large"
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "min_servers" {
  description = "Minimum number of ECS servers to run."
  default     = 1
}

variable "max_servers" {
  description = "Maximum number of ECS servers to run."
  default     = 10
}

variable "name_prefix" {
  default = ""
}

variable "region" {
  description = "The region of AWS, for AMI lookups."
  default     = "us-west-2"
}

variable "security_group_ids" {
  description = "A list of Security group IDs to apply to the launch configuration"
  type        = "list"
  default     = []
}

variable "servers" {
  description = "The number of servers to launch."
  default     = "1"
}

variable "subnet_id" {
  description = "The AWS Subnet ID in which you want to delpoy your instances"
  type        = "list"
}

variable "tagName" {
  description = "Name tag for the servers"
  default     = "ECS Node"
}

variable "user_data" {
  description = ""
  default     = ""
}

variable "vpc_id" {
  description = "The AWS VPC ID which you want to deploy your instances"
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
  type        = "list"
  default     = ["OldestLaunchConfiguration", "ClosestToNextInstanceHour", "Default"]
}

variable "placement_group" {
  description = "The name of the placement group into which you'll launch your instances, if any"
  default     = ""
}

variable "tags_ag" {
  description = "Additional tags for Autoscaling group. A list of tag blocks. Each element is a map with key, value, and propagate_at_launch."
  default     = []
}
