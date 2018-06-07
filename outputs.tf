output "cluster_id" {
  description = "ECS Cluster ID"
  value       = "${element(concat(aws_ecs_cluster.this.*.id, list("")), 0)}"
}

output "cluster_name" {
  description = "ECS Cluster Name"
  value       = "${element(concat(aws_ecs_cluster.this.*.name, list("")), 0)}"
}

output "cluster_security_group_id" {
  description = "ECS Cluster Security Group ID"
  value       = "${module.sg.id}"
}

output "cluster_size" {
  description = "Cluster size. Number of EC2 instances desired"
  value       = "${var.servers}"
}

output "autoscaling_group" {
  description = "Map of ASG info"

  value = {
    id   = "${module.asg.autoscaling_group_id}"
    name = "${module.asg.autoscaling_group_name}"
    arn  = "${module.asg.autoscaling_group_arn}"
  }
}
