output "cluster_id" {
  description = "ECS Cluster ID"
  value       = "${module.disabled.cluster_id}"
}

output "cluster_name" {
  description = "ECS Cluster Name"
  value       = "${module.disabled.cluster_name}"
}

output "cluster_security_group_id" {
  description = "ECS Cluster Security Group ID"
  value       = "${module.disabled.cluster_security_group_id}"
}

output "autoscaling_group" {
  description = "Map of ASG info"
  value       = "${module.disabled.autoscaling_group}"
}
