variable "environment" {
  default = "one"
}

variable "key_name" {
  description = "SSH key name to use"
  default     = "devops20170606"
}

variable "region" {
  default = "us-west-2"
}

variable "instance_type" {
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
  default     = "m5.large"
}
