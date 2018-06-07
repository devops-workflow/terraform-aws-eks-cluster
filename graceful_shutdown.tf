# Thank God for Circle CI for this post
# https://circleci.com/blog/graceful-shutdown-using-aws/

resource "aws_autoscaling_lifecycle_hook" "graceful_shutdown_asg_hook" {
  count                  = "${module.enabled.value}"
  name                   = "graceful_shutdown_asg"
  autoscaling_group_name = "${module.asg.autoscaling_group_name}"
  default_result         = "CONTINUE"
  heartbeat_timeout      = "${var.heartbeat_timeout}"
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
}
