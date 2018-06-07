###
### Terraform AWS EKS Cluster
###

# Documentation references:

# WIP

module "enabled" {
  source  = "devops-workflow/boolean/local"
  version = "0.1.1"
  value   = "${var.enabled}"
}

# Define composite variables for resources
# TODO: add new variables
module "label" {
  source        = "devops-workflow/label/local"
  version       = "0.2.1"
  organization  = "${var.organization}"
  name          = "${var.name}"
  namespace-env = "${var.namespace-env}"
  namespace-org = "${var.namespace-org}"
  environment   = "${var.environment}"
  delimiter     = "${var.delimiter}"
  attributes    = "${var.attributes}"
  tags          = "${var.tags}"
}

# Lookup ECS optimised Amazon AMI in the selected region
# TODO: change to EKS ami lookup
data "aws_ami" "aws_optimized_ecs" {
  #count     = "${module.enabled.value}"
  #count       = "${var.lookup_latest_ami ? 1 : 0}"
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-${var.ami_version}-amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# TODO: EKS user data template and vars
data "template_file" "user_data" {
  # TODO: option to pass in
  # Cannot disable due to reference
  #count     = "${module.enabled.value}"
  template = "${file("${path.module}/templates/user_data.sh")}"

  vars {
    additional_user_data_script = "${var.additional_user_data_script}"
    cluster_name                = "${aws_ecs_cluster.this.name}"
    docker_storage_size         = "${var.docker_storage_size}"
    dockerhub_token             = "${var.dockerhub_token}"
    dockerhub_email             = "${var.dockerhub_email}"
  }
}

data "aws_vpc" "vpc" {
  #count = "${module.enabled.value}"
  id = "${var.vpc_id}"
}

###
### AWS EKS Cluster
###
# TODO: EKS Cluster
resource "aws_ecs_cluster" "this" {
  #count = "${module.enabled.value}"
  name = "${module.label.id}"

  lifecycle {
    create_before_destroy = true
  }
}

# TODO: change to released module & version
# TODO: add new tag variables
module "asg" {
  #source    = "git::https://github.com/devops-workflow/terraform-aws-autoscaling.git?ref=tags/v0.1.3"
  source        = "git::https://github.com/devops-workflow/terraform-aws-autoscaling.git"
  enabled       = "${module.enabled.value}"
  name          = "${module.label.name}"
  attributes    = "${var.attributes}"
  delimiter     = "${var.delimiter}"
  environment   = "${var.environment}"
  namespace-env = "${var.namespace-env}"
  namespace-org = "${var.namespace-org}"
  organization  = "${var.organization}"
  tags          = "${var.tags}"

  // Launch configuration
  associate_public_ip_address = "${var.associate_public_ip_address}"
  ebs_optimized               = "${var.ebs_optimized}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs_profile.name}"
  image_id                    = "${var.ami == "" ? data.aws_ami.aws_optimized_ecs.id : var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${concat(list(module.sg.id), var.security_group_ids)}"]
  user_data                   = "${coalesce(var.user_data, data.template_file.user_data.rendered)}"

  ebs_block_device = [{
    device_name           = "/dev/xvdcz"
    volume_size           = "${var.docker_storage_size}"
    volume_type           = "gp2"
    delete_on_termination = true
  }]

  // Autoscaling group
  placement_group      = "${var.placement_group}"
  termination_policies = ["${var.termination_policies}"]
  vpc_zone_identifier  = ["${var.subnet_id}"]

  # TODO: make setable: EC2 or ELB ??
  health_check_type = "EC2"
  min_size          = "${var.min_servers}"
  max_size          = "${var.max_servers}"
  desired_capacity  = "${var.servers}"

  #tags_ag           = ["${var.tags_ag}"]
}

# TODO: add new tag variables
module "sg" {
  source              = "devops-workflow/security-group/aws"
  version             = "2.1.0"
  enabled             = "${module.enabled.value}"
  name                = "${module.label.name}"
  attributes          = "${var.attributes}"
  delimiter           = "${var.delimiter}"
  environment         = "${var.environment}"
  namespace-env       = "${var.namespace-env}"
  namespace-org       = "${var.namespace-org}"
  organization        = "${var.organization}"
  tags                = "${var.tags}"
  description         = "Container Instance Allowed Ports"
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  ingress_cidr_blocks = "${var.allowed_cidr_blocks}"
  ingress_rules       = ["all-tcp", "all-udp"]
  vpc_id              = "${data.aws_vpc.vpc.id}"
}
