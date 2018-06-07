module "disabled" {
  source      = "../"
  enabled     = false
  name        = "disabled"
  environment = "one"
  key_name    = ""
  subnet_id   = []
  vpc_id      = "${data.aws_vpc.vpc.id}"
}
