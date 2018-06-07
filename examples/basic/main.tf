module "basic" {
  source        = "../"
  name          = "ecs-basic"
  environment   = "one"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  subnet_id     = ["${data.aws_subnet_ids.private_subnet_ids.ids}"]
  vpc_id        = "${data.aws_vpc.vpc.id}"
}
