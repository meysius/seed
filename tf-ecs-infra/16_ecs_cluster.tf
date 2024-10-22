resource "aws_ecs_cluster" "cluster" {
  name = "pacely"
}

resource "aws_launch_configuration" "t3_micro" {
  name                 = "pacely-ecs-t3-micro"
  image_id             = local.ecs_ec2_ami
  instance_type        = "t3.micro"
  security_groups      = [aws_security_group.ecs.id]
  iam_instance_profile =  aws_iam_instance_profile.ecs_agent.name
  key_name             = local.keypair_name
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=pacely >> /etc/ecs/ecs.config"
}

resource "aws_autoscaling_group" "t3_micro" {
  name                      = "pacely-t3-micro-ecs-fleet"
  vpc_zone_identifier       = data.aws_subnets.vpc_subnet_ids.ids
  launch_configuration      = aws_launch_configuration.t3_micro.name
  protect_from_scale_in     = true

  min_size                  = local.t3_micro_fleet_min_instances
  max_size                  = local.t3_micro_fleet_max_instances

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "t3_micro" {
  name = "pacely-t3-micro-ec2-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.t3_micro.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status           = "ENABLED"
      target_capacity  = 100
    }
  }
}

resource "aws_launch_configuration" "t3_small" {
  name                 = "pacely-ecs-t3-small"
  image_id             = local.ecs_ec2_ami
  instance_type        = "t3.small"
  security_groups      = [aws_security_group.ecs.id]
  iam_instance_profile =  aws_iam_instance_profile.ecs_agent.name
  key_name             = local.keypair_name
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=pacely >> /etc/ecs/ecs.config"
}

resource "aws_autoscaling_group" "t3_small" {
  name                      = "pacely-t3-small-ecs-fleet"
  vpc_zone_identifier       = data.aws_subnets.vpc_subnet_ids.ids
  launch_configuration      = aws_launch_configuration.t3_small.name
  protect_from_scale_in     = true

  min_size                  = local.t3_small_fleet_min_instances
  max_size                  = local.t3_small_fleet_max_instances

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "t3_small" {
  name = "pacely-t3-small-ec2-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.t3_small.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status           = "ENABLED"
      target_capacity  = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name = aws_ecs_cluster.cluster.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT", aws_ecs_capacity_provider.t3_micro.name, aws_ecs_capacity_provider.t3_small.name]
}
