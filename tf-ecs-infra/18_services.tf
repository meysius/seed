resource "aws_ecs_service" "webapp" {
  name            = "webapp"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${replace(aws_ecs_task_definition.webapp.arn, ":${aws_ecs_task_definition.webapp.revision}", "")}"
  iam_role        = aws_iam_role.ecs_service.arn
  health_check_grace_period_seconds = 300

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.t3_micro.name
    weight            = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  depends_on      = [
    aws_db_instance.database,
    aws_elasticache_replication_group.redis,
    aws_iam_role.ecs_service,
    aws_alb_listener.https
  ]

  deployment_minimum_healthy_percent = local.min_health_percentage
  deployment_maximum_percent = local.max_health_percentage

  load_balancer {
    target_group_arn = aws_alb_target_group.webapp.arn
    container_name   = "webapp"
    container_port   = 3000
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [ task_definition, desired_count ]
  }
}

resource "aws_appautoscaling_target" "webapp" {
  min_capacity       = local.webapp_min_tasks
  max_capacity       = local.webapp_max_tasks
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.webapp.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "webapp_memory_based_autoscaleing" {
  name               = "webapp-memory-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.webapp.resource_id
  scalable_dimension = aws_appautoscaling_target.webapp.scalable_dimension
  service_namespace  = aws_appautoscaling_target.webapp.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.webapp_mem_scaling_target
    scale_in_cooldown  = local.webapp_scale_down_cooldown
    scale_out_cooldown = local.webapp_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.webapp]
}

resource "aws_appautoscaling_policy" "webapp_cpu_based_autoscaleing" {
  name               = "webapp-cpu-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.webapp.resource_id
  scalable_dimension = aws_appautoscaling_target.webapp.scalable_dimension
  service_namespace  = aws_appautoscaling_target.webapp.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.webapp_cpu_scaling_target
    scale_in_cooldown  = local.webapp_scale_down_cooldown
    scale_out_cooldown = local.webapp_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.webapp]
}

# ---------


resource "aws_ecs_service" "identity" {
  name            = "identity"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${replace(aws_ecs_task_definition.identity.arn, ":${aws_ecs_task_definition.identity.revision}", "")}"
  iam_role        = aws_iam_role.ecs_service.arn
  health_check_grace_period_seconds = 300

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.t3_micro.name
    weight            = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  depends_on      = [
    aws_db_instance.database,
    aws_elasticache_replication_group.redis,
    aws_iam_role.ecs_service,
    aws_alb_listener.https
  ]

  deployment_minimum_healthy_percent = local.min_health_percentage
  deployment_maximum_percent = local.max_health_percentage

  load_balancer {
    target_group_arn = aws_alb_target_group.identity.arn
    container_name   = "identity"
    container_port   = 4000
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [ task_definition, desired_count ]
  }
}


resource "aws_appautoscaling_target" "identity" {
  min_capacity       = local.identity_min_tasks
  max_capacity       = local.identity_max_tasks
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.identity.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "identity_memory_based_autoscaleing" {
  name               = "identity-memory-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.identity.resource_id
  scalable_dimension = aws_appautoscaling_target.identity.scalable_dimension
  service_namespace  = aws_appautoscaling_target.identity.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.identity_mem_scaling_target
    scale_in_cooldown  = local.identity_scale_down_cooldown
    scale_out_cooldown = local.identity_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.identity]
}

resource "aws_appautoscaling_policy" "identity_cpu_based_autoscaleing" {
  name               = "identity-cpu-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.identity.resource_id
  scalable_dimension = aws_appautoscaling_target.identity.scalable_dimension
  service_namespace  = aws_appautoscaling_target.identity.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.identity_cpu_scaling_target
    scale_in_cooldown  = local.identity_scale_down_cooldown
    scale_out_cooldown = local.identity_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.identity]
}

# ---------

resource "aws_ecs_service" "ticketing" {
  name            = "ticketing"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${replace(aws_ecs_task_definition.ticketing.arn, ":${aws_ecs_task_definition.ticketing.revision}", "")}"
  iam_role        = aws_iam_role.ecs_service.arn
  health_check_grace_period_seconds = 300

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.t3_micro.name
    weight            = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  depends_on      = [
    aws_db_instance.database,
    aws_elasticache_replication_group.redis,
    aws_iam_role.ecs_service,
    aws_alb_listener.https
  ]

  deployment_minimum_healthy_percent = local.min_health_percentage
  deployment_maximum_percent = local.max_health_percentage

  load_balancer {
    target_group_arn = aws_alb_target_group.ticketing.arn
    container_name   = "ticketing"
    container_port   = 4000
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [ task_definition, desired_count ]
  }
}


resource "aws_appautoscaling_target" "ticketing" {
  min_capacity       = local.ticketing_min_tasks
  max_capacity       = local.ticketing_max_tasks
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.ticketing.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ticketing_memory_based_autoscaleing" {
  name               = "ticketing-memory-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ticketing.resource_id
  scalable_dimension = aws_appautoscaling_target.ticketing.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ticketing.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.ticketing_mem_scaling_target
    scale_in_cooldown  = local.ticketing_scale_down_cooldown
    scale_out_cooldown = local.ticketing_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.ticketing]
}

resource "aws_appautoscaling_policy" "ticketing_cpu_based_autoscaleing" {
  name               = "ticketing-cpu-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ticketing.resource_id
  scalable_dimension = aws_appautoscaling_target.ticketing.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ticketing.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.ticketing_cpu_scaling_target
    scale_in_cooldown  = local.ticketing_scale_down_cooldown
    scale_out_cooldown = local.ticketing_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.ticketing]
}

# ---------

resource "aws_ecs_service" "activity" {
  name            = "activity"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${replace(aws_ecs_task_definition.activity.arn, ":${aws_ecs_task_definition.activity.revision}", "")}"
  iam_role        = aws_iam_role.ecs_service.arn
  health_check_grace_period_seconds = 300

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.t3_micro.name
    weight            = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  depends_on      = [
    aws_db_instance.database,
    aws_elasticache_replication_group.redis,
    aws_iam_role.ecs_service,
    aws_alb_listener.https
  ]

  deployment_minimum_healthy_percent = local.min_health_percentage
  deployment_maximum_percent = local.max_health_percentage

  load_balancer {
    target_group_arn = aws_alb_target_group.activity.arn
    container_name   = "activity"
    container_port   = 4000
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [ task_definition, desired_count ]
  }
}

resource "aws_appautoscaling_target" "activity" {
  min_capacity       = local.activity_min_tasks
  max_capacity       = local.activity_max_tasks
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.activity.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "activity_memory_based_autoscaleing" {
  name               = "activity-memory-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.activity.resource_id
  scalable_dimension = aws_appautoscaling_target.activity.scalable_dimension
  service_namespace  = aws_appautoscaling_target.activity.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.activity_mem_scaling_target
    scale_in_cooldown  = local.activity_scale_down_cooldown
    scale_out_cooldown = local.activity_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.activity]
}

resource "aws_appautoscaling_policy" "activity_cpu_based_autoscaleing" {
  name               = "activity-cpu-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.activity.resource_id
  scalable_dimension = aws_appautoscaling_target.activity.scalable_dimension
  service_namespace  = aws_appautoscaling_target.activity.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.activity_cpu_scaling_target
    scale_in_cooldown  = local.activity_scale_down_cooldown
    scale_out_cooldown = local.activity_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.activity]
}

# ---------

resource "aws_ecs_service" "coding" {
  name            = "coding"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${replace(aws_ecs_task_definition.coding.arn, ":${aws_ecs_task_definition.coding.revision}", "")}"
  iam_role        = aws_iam_role.ecs_service.arn
  health_check_grace_period_seconds = 300

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.t3_micro.name
    weight            = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  depends_on      = [
    aws_db_instance.database,
    aws_elasticache_replication_group.redis,
    aws_iam_role.ecs_service,
    aws_alb_listener.https
  ]

  deployment_minimum_healthy_percent = local.min_health_percentage
  deployment_maximum_percent = local.max_health_percentage

  load_balancer {
    target_group_arn = aws_alb_target_group.coding.arn
    container_name   = "coding"
    container_port   = 4000
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [ task_definition, desired_count ]
  }
}

resource "aws_appautoscaling_target" "coding" {
  min_capacity       = local.coding_min_tasks
  max_capacity       = local.coding_max_tasks
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.coding.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "coding_memory_based_autoscaleing" {
  name               = "coding-memory-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.coding.resource_id
  scalable_dimension = aws_appautoscaling_target.coding.scalable_dimension
  service_namespace  = aws_appautoscaling_target.coding.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.coding_mem_scaling_target
    scale_in_cooldown  = local.coding_scale_down_cooldown
    scale_out_cooldown = local.coding_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.coding]
}

resource "aws_appautoscaling_policy" "coding_cpu_based_autoscaleing" {
  name               = "coding-cpu-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.coding.resource_id
  scalable_dimension = aws_appautoscaling_target.coding.scalable_dimension
  service_namespace  = aws_appautoscaling_target.coding.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.coding_cpu_scaling_target
    scale_in_cooldown  = local.coding_scale_down_cooldown
    scale_out_cooldown = local.coding_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.coding]
}
# ---------

resource "aws_ecs_service" "identity_worker" {
  name            = "identity-worker"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${replace(aws_ecs_task_definition.identity_worker.arn, ":${aws_ecs_task_definition.identity_worker.revision}", "")}"

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.t3_micro.name
    weight            = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  depends_on      = [
    aws_db_instance.database,
    aws_elasticache_replication_group.redis,
    aws_iam_role.ecs_service,
    aws_alb_listener.https
  ]

  deployment_minimum_healthy_percent = local.min_health_percentage
  deployment_maximum_percent = local.max_health_percentage
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [ task_definition, desired_count ]
  }
}

resource "aws_appautoscaling_target" "identity_worker" {
  min_capacity       = local.identity_worker_min_tasks
  max_capacity       = local.identity_worker_max_tasks
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.identity_worker.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "identity_worker_memory_based_autoscaleing" {
  name               = "identity-worker-memory-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.identity_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.identity_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.identity_worker.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.identity_worker_mem_scaling_target
    scale_in_cooldown  = local.identity_worker_scale_down_cooldown
    scale_out_cooldown = local.identity_worker_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.identity_worker]
}

resource "aws_appautoscaling_policy" "identity_worker_cpu_based_autoscaleing" {
  name               = "identity-worker-cpu-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.identity_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.identity_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.identity_worker.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.identity_worker_cpu_scaling_target
    scale_in_cooldown  = local.identity_worker_scale_down_cooldown
    scale_out_cooldown = local.identity_worker_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.identity_worker]
}
# ---------

resource "aws_ecs_service" "ticketing_worker" {
  name            = "ticketing-worker"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${replace(aws_ecs_task_definition.ticketing_worker.arn, ":${aws_ecs_task_definition.ticketing_worker.revision}", "")}"

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.t3_micro.name
    weight            = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  depends_on      = [
    aws_db_instance.database,
    aws_elasticache_replication_group.redis,
    aws_iam_role.ecs_service,
    aws_alb_listener.https
  ]

  deployment_minimum_healthy_percent = local.min_health_percentage
  deployment_maximum_percent = local.max_health_percentage

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [ task_definition, desired_count ]
  }
}

resource "aws_appautoscaling_target" "ticketing_worker" {
  min_capacity       = local.ticketing_worker_min_tasks
  max_capacity       = local.ticketing_worker_max_tasks
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.ticketing_worker.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ticketing_worker_memory_based_autoscaleing" {
  name               = "ticketing-worker-memory-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ticketing_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.ticketing_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ticketing_worker.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.ticketing_worker_mem_scaling_target
    scale_in_cooldown  = local.ticketing_worker_scale_down_cooldown
    scale_out_cooldown = local.ticketing_worker_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.ticketing_worker]
}

resource "aws_appautoscaling_policy" "ticketing_worker_cpu_based_autoscaleing" {
  name               = "ticketing-worker-cpu-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ticketing_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.ticketing_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ticketing_worker.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.ticketing_worker_cpu_scaling_target
    scale_in_cooldown  = local.ticketing_worker_scale_down_cooldown
    scale_out_cooldown = local.ticketing_worker_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.ticketing_worker]
}
# ---------

resource "aws_ecs_service" "activity_worker" {
  name            = "activity-worker"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${replace(aws_ecs_task_definition.activity_worker.arn, ":${aws_ecs_task_definition.activity_worker.revision}", "")}"

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.t3_micro.name
    weight            = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  depends_on      = [
    aws_db_instance.database,
    aws_elasticache_replication_group.redis,
    aws_iam_role.ecs_service,
    aws_alb_listener.https
  ]

  deployment_minimum_healthy_percent = local.min_health_percentage
  deployment_maximum_percent = local.max_health_percentage
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [ task_definition, desired_count ]
  }
}

resource "aws_appautoscaling_target" "activity_worker" {
  min_capacity       = local.activity_worker_min_tasks
  max_capacity       = local.activity_worker_max_tasks
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.activity_worker.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "activity_worker_memory_based_autoscaleing" {
  name               = "activity-worker-memory-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.activity_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.activity_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.activity_worker.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.activity_worker_mem_scaling_target
    scale_in_cooldown  = local.activity_worker_scale_down_cooldown
    scale_out_cooldown = local.activity_worker_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.activity_worker]
}

resource "aws_appautoscaling_policy" "activity_worker_cpu_based_autoscaleing" {
  name               = "activity-worker-cpu-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.activity_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.activity_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.activity_worker.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.activity_worker_cpu_scaling_target
    scale_in_cooldown  = local.activity_worker_scale_down_cooldown
    scale_out_cooldown = local.activity_worker_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.activity_worker]
}

# ---------

resource "aws_ecs_service" "coding_worker" {
  name            = "coding-worker"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = "${replace(aws_ecs_task_definition.coding_worker.arn, ":${aws_ecs_task_definition.coding_worker.revision}", "")}"

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.t3_micro.name
    weight            = 1
  }

  deployment_circuit_breaker {
    enable = true
    rollback = true
  }

  depends_on      = [
    aws_db_instance.database,
    aws_elasticache_replication_group.redis,
    aws_iam_role.ecs_service,
    aws_alb_listener.https
  ]

  deployment_minimum_healthy_percent = local.min_health_percentage
  deployment_maximum_percent = local.max_health_percentage
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  lifecycle {
    ignore_changes = [ task_definition, desired_count ]
  }
}

resource "aws_appautoscaling_target" "coding_worker" {
  min_capacity       = local.coding_worker_min_tasks
  max_capacity       = local.coding_worker_max_tasks
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.coding_worker.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "coding_worker_memory_based_autoscaleing" {
  name               = "coding-worker-memory-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.coding_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.coding_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.coding_worker.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = local.coding_worker_mem_scaling_target
    scale_in_cooldown  = local.coding_worker_scale_down_cooldown
    scale_out_cooldown = local.coding_worker_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.coding_worker]
}

resource "aws_appautoscaling_policy" "coding_worker_cpu_based_autoscaleing" {
  name               = "coding-worker-cpu-based-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.coding_worker.resource_id
  scalable_dimension = aws_appautoscaling_target.coding_worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.coding_worker.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = local.coding_worker_cpu_scaling_target
    scale_in_cooldown  = local.coding_worker_scale_down_cooldown
    scale_out_cooldown = local.coding_worker_scale_up_cooldown
  }

  depends_on = [aws_ecs_service.coding_worker]
}
