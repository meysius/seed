resource "aws_instance" "rabbitmq" {
	ami = "ami-0fb653ca2d3203ac1" # ubuntu 20.04
	instance_type = local.rabbitmq_instance_size
	key_name = local.keypair_name
	user_data = templatefile(
    "rabbitmq-init.sh",
    {
      user       = var.rabbitmq_user
      pass       = var.rabbitmq_pass
      admin_user = var.rabbitmq_admin_user
      admin_pass = var.rabbitmq_admin_pass
    }
  )
  vpc_security_group_ids = [aws_security_group.rabbitmq.id]
  subnet_id = aws_subnet.public_subnet[keys(local.vpc_subnets)[0]].id

	tags = {
		Name = "${local.env_name}-pacely-rabbitmq"
	}

  lifecycle {
    prevent_destroy = true
    ignore_changes = [ ami, instance_type, user_data ]
  }
}

resource "aws_lb_target_group_attachment" "rabbitmq" {
  target_group_arn = aws_alb_target_group.rabbitmq.arn
  target_id        = aws_instance.rabbitmq.id
  port             = 15672
}
