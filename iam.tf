###
### EKS Cluster IAM
###

# TODO: redo for EKS

resource "aws_iam_instance_profile" "ecs_profile" {
  # Can't disable due to reference
  #count       = "${module.enabled.value}"
  # TODO: use label
  name_prefix = "${replace(format("%.102s", replace("tf-ECSProfile-${var.name}-", "_", "-")), "/\\s/", "-")}"

  role = "${aws_iam_role.ecs_role.name}"
  path = "${var.iam_path}"
}

resource "aws_iam_role" "ecs_role" {
  # Can't disable due to reference
  #count       = "${module.enabled.value}"
  # TODO: use label
  name_prefix = "${replace(format("%.32s", replace("tf-ECSInRole-${var.name}-", "_", "-")), "/\\s/", "-")}"

  path = "${var.iam_path}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
      "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com"]

    },
    "Effect": "Allow",
    "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs_policy" {
  count       = "${module.enabled.value ? length(var.custom_iam_policy) > 0 ? 0 : 1 : 0}"
  name_prefix = "${replace(format("%.102s", replace("tf-ECSInPol-${var.name}-", "_", "-")), "/\\s/", "-")}"
  description = "A terraform created policy for ECS"
  path        = "${var.iam_path}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "custom_ecs_policy" {
  count       = "${module.enabled.value ? length(var.custom_iam_policy) > 0 ? 1 : 0 : 0}"
  name_prefix = "${replace(format("%.102s", replace("tf-ECSInPol-${var.name}-", "_", "-")), "/\\s/", "-")}"
  description = "A terraform created policy for ECS"
  path        = "${var.iam_path}"
  policy      = "${var.custom_iam_policy}"
}

resource "aws_iam_policy_attachment" "attach_ecs" {
  count      = "${module.enabled.value}"
  name       = "ecs-attachment"
  roles      = ["${aws_iam_role.ecs_role.name}"]
  policy_arn = "${element(concat(aws_iam_policy.ecs_policy.*.arn, aws_iam_policy.custom_ecs_policy.*.arn), 0)}"
}
