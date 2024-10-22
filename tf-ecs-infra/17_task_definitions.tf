resource "aws_ecs_task_definition" "webapp" {
  family = "webapp"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  container_definitions = jsonencode([
    {
      name      = "webapp"
      image     = aws_ecr_repository.webapp.repository_url
      memoryReservation  = local.webapp_min_memory
      memory             = local.webapp_max_memory
      cpu                = local.webapp_cpu
      essential = true
      portMappings = [
        {
          hostPort      = 0
          containerPort = 3000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group":         aws_cloudwatch_log_group.webapp.name,
          "awslogs-region":        local.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        { "name": "GOOGLE_CLIENT_ID",      "valueFrom": aws_ssm_parameter.google_client_id.arn },
        { "name": "STRIPE_PUBLIC_KEY",     "valueFrom": aws_ssm_parameter.webapp_stripe_public_key.arn },
        { "name": "SLACK_CLIENT_ID",       "valueFrom": aws_ssm_parameter.slack_client_id.arn },
        { "name": "GITHUB_APP_NAME",       "valueFrom": aws_ssm_parameter.webapp_github_app_name.arn },
        { "name": "POSTHOG_KEY",           "valueFrom": aws_ssm_parameter.webapp_posthog_key.arn }
      ],
      "environment": [
        { "name": "WEBAPP_BASE_URL",     "value": "https://${local.subdomain_suffix == "" ? "" : "${local.subdomain_suffix}." }${local.domain}" },
        { "name": "IDENTITY_BASE_URL",   "value": "https://identity${local.subdomain_suffix}.${local.domain}" },
        { "name": "TICKETING_BASE_URL",  "value": "https://ticketing${local.subdomain_suffix}.${local.domain}" },
        { "name": "ACTIVITY_BASE_URL",   "value": "https://activity${local.subdomain_suffix}.${local.domain}" },
        { "name": "CODING_BASE_URL",     "value": "https://coding${local.subdomain_suffix}.${local.domain}" },
        { "name": "IDENTITY_WS_URL",     "value": "wss://identity${local.subdomain_suffix}.${local.domain}" },
        { "name": "TICKETING_WS_URL",    "value": "wss://ticketing${local.subdomain_suffix}.${local.domain}" },
        { "name": "ACTIVITY_WS_URL",     "value": "wss://activity${local.subdomain_suffix}.${local.domain}" },
        { "name": "CODING_WS_URL",       "value": "wss://coding${local.subdomain_suffix}.${local.domain}" },
        { "name": "INTERNALLY_USED_IDENTITY_BASE_URL", "value": "https://identity${local.subdomain_suffix}.${local.domain}" },
        { "name": "SLACK_REDIRECT_DOMAIN", "value": "https://${local.subdomain_suffix == "" ? "" : "${local.subdomain_suffix}." }${local.domain}" },
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "identity" {
  family     = "identity"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  depends_on = [aws_db_instance.database, aws_elasticache_replication_group.redis]
  container_definitions = jsonencode([
    {
      name      = "identity"
      image     = aws_ecr_repository.identity.repository_url
      memoryReservation  = local.identity_min_memory
      memory             = local.identity_max_memory
      cpu                = local.identity_cpu
      essential = true
      portMappings = [
        {
          hostPort      = 0
          containerPort = 4000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group":         aws_cloudwatch_log_group.identity.name,
          "awslogs-region":        local.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        { "name": "SECRET_KEY_BASE",         "valueFrom": aws_ssm_parameter.identity_secret_key_base.arn },
        { "name": "ADMIN_USER",              "valueFrom": aws_ssm_parameter.admin_user.arn },
        { "name": "ADMIN_PASS",              "valueFrom": aws_ssm_parameter.admin_pass.arn },
        { "name": "JWT_HMAC_KEY",            "valueFrom": aws_ssm_parameter.jwt_hmac_key.arn },
        { "name": "POSTGRES_CA_CERT_PATH",   "valueFrom": aws_ssm_parameter.postgres_ca_cert_path.arn },
        { "name": "POSTGRES_HOST",           "valueFrom": aws_ssm_parameter.postgres_host.arn },
        { "name": "POSTGRES_PORT",           "valueFrom": aws_ssm_parameter.postgres_port.arn },
        { "name": "POSTGRES_USER",           "valueFrom": aws_ssm_parameter.postgres_user.arn },
        { "name": "POSTGRES_PASS",           "valueFrom": aws_ssm_parameter.postgres_pass.arn },
        { "name": "POSTGRES_DB",             "valueFrom": aws_ssm_parameter.identity_db_name.arn },
        { "name": "POSTGRES_POOL_SIZE",      "valueFrom": aws_ssm_parameter.identity_db_pool_size.arn },
        { "name": "REDIS_HOST",              "valueFrom": aws_ssm_parameter.redis_host.arn },
        { "name": "REDIS_PORT",              "valueFrom": aws_ssm_parameter.redis_port.arn },
        { "name": "REDIS_DB",                "valueFrom": aws_ssm_parameter.identity_redis_db.arn },
        { "name": "RABBITMQ_HOST",           "valueFrom": aws_ssm_parameter.rabbitmq_host.arn },
        { "name": "RABBITMQ_PORT",           "valueFrom": aws_ssm_parameter.rabbitmq_port.arn },
        { "name": "RABBITMQ_USERNAME",       "valueFrom": aws_ssm_parameter.rabbitmq_user.arn },
        { "name": "RABBITMQ_PASSWORD",       "valueFrom": aws_ssm_parameter.rabbitmq_pass.arn },
        { "name": "STRIPE_SECRET_KEY",       "valueFrom": aws_ssm_parameter.stripe_secret_key.arn },
        { "name": "GOOGLE_CLIENT_ID",        "valueFrom": aws_ssm_parameter.google_client_id.arn },
        { "name": "SENTRY_ENV",              "valueFrom": aws_ssm_parameter.sentry_env.arn },
        { "name": "SENTRY_DSN",              "valueFrom": aws_ssm_parameter.sentry_dsn.arn },
        { "name": "SES_ACCESS_KEY_ID",       "valueFrom": aws_ssm_parameter.identity_ses_access_key_id.arn },
        { "name": "SES_SECRET_ACCESS_KEY",   "valueFrom": aws_ssm_parameter.identity_ses_secret_access_key.arn },
        { "name": "MAIL_FROM_DOMAIN",        "valueFrom": aws_ssm_parameter.identity_mail_from_domain.arn },
        { "name": "SLACK_CLIENT_ID",         "valueFrom": aws_ssm_parameter.slack_client_id.arn },
        { "name": "SLACK_CLIENT_SECRET",     "valueFrom": aws_ssm_parameter.identity_slack_client_secret.arn },
        { "name": "SLACK_SIGNING_SECRET",    "valueFrom": aws_ssm_parameter.identity_slack_signing_secret.arn },
        { "name": "CLOAK_KEY",               "valueFrom": aws_ssm_parameter.identity_cloak_key.arn }
      ],
      "environment": [
        { "name": "PORT",                    "value": "4000" },
        { "name": "IS_WORKER",               "value": "false" },
        { "name": "IS_RABBITMQ_SUBCSCRIBER", "value": "true" },
        { "name": "APP_BASE_URL",            "value": "https://${local.subdomain_suffix == "" ? "" : "${local.subdomain_suffix}." }${local.domain}" },
        { "name": "SEND_REAL_EMAILS",        "value": "true" }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "identity_worker" {
  family     = "identity-worker"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  depends_on = [aws_db_instance.database, aws_elasticache_replication_group.redis]
  container_definitions = jsonencode([
    {
      name      = "identity-worker"
      image     = aws_ecr_repository.identity.repository_url
      memoryReservation  = local.identity_worker_min_memory
      memory             = local.identity_worker_max_memory
      cpu                = local.identity_worker_cpu
      essential = true
      portMappings = [
        {
          hostPort      = 0
          containerPort = 4000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group":         aws_cloudwatch_log_group.identity_worker.name,
          "awslogs-region":        local.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        { "name": "SECRET_KEY_BASE",         "valueFrom": aws_ssm_parameter.identity_secret_key_base.arn },
        { "name": "ADMIN_USER",              "valueFrom": aws_ssm_parameter.admin_user.arn },
        { "name": "ADMIN_PASS",              "valueFrom": aws_ssm_parameter.admin_pass.arn },
        { "name": "JWT_HMAC_KEY",            "valueFrom": aws_ssm_parameter.jwt_hmac_key.arn },
        { "name": "POSTGRES_CA_CERT_PATH",   "valueFrom": aws_ssm_parameter.postgres_ca_cert_path.arn },
        { "name": "POSTGRES_HOST",           "valueFrom": aws_ssm_parameter.postgres_host.arn },
        { "name": "POSTGRES_PORT",           "valueFrom": aws_ssm_parameter.postgres_port.arn },
        { "name": "POSTGRES_USER",           "valueFrom": aws_ssm_parameter.postgres_user.arn },
        { "name": "POSTGRES_PASS",           "valueFrom": aws_ssm_parameter.postgres_pass.arn },
        { "name": "POSTGRES_DB",             "valueFrom": aws_ssm_parameter.identity_db_name.arn },
        { "name": "POSTGRES_POOL_SIZE",      "valueFrom": aws_ssm_parameter.identity_db_pool_size.arn },
        { "name": "REDIS_HOST",              "valueFrom": aws_ssm_parameter.redis_host.arn },
        { "name": "REDIS_PORT",              "valueFrom": aws_ssm_parameter.redis_port.arn },
        { "name": "REDIS_DB",                "valueFrom": aws_ssm_parameter.identity_redis_db.arn },
        { "name": "RABBITMQ_HOST",           "valueFrom": aws_ssm_parameter.rabbitmq_host.arn },
        { "name": "RABBITMQ_PORT",           "valueFrom": aws_ssm_parameter.rabbitmq_port.arn },
        { "name": "RABBITMQ_USERNAME",       "valueFrom": aws_ssm_parameter.rabbitmq_user.arn },
        { "name": "RABBITMQ_PASSWORD",       "valueFrom": aws_ssm_parameter.rabbitmq_pass.arn },
        { "name": "STRIPE_SECRET_KEY",       "valueFrom": aws_ssm_parameter.stripe_secret_key.arn },
        { "name": "GOOGLE_CLIENT_ID",        "valueFrom": aws_ssm_parameter.google_client_id.arn },
        { "name": "SENTRY_ENV",              "valueFrom": aws_ssm_parameter.sentry_env.arn },
        { "name": "SENTRY_DSN",              "valueFrom": aws_ssm_parameter.sentry_dsn.arn },
        { "name": "SES_ACCESS_KEY_ID",       "valueFrom": aws_ssm_parameter.identity_ses_access_key_id.arn },
        { "name": "SES_SECRET_ACCESS_KEY",   "valueFrom": aws_ssm_parameter.identity_ses_secret_access_key.arn },
        { "name": "MAIL_FROM_DOMAIN",        "valueFrom": aws_ssm_parameter.identity_mail_from_domain.arn },
        { "name": "SLACK_CLIENT_ID",         "valueFrom": aws_ssm_parameter.slack_client_id.arn },
        { "name": "SLACK_CLIENT_SECRET",     "valueFrom": aws_ssm_parameter.identity_slack_client_secret.arn },
        { "name": "SLACK_SIGNING_SECRET",    "valueFrom": aws_ssm_parameter.identity_slack_signing_secret.arn },
        { "name": "CLOAK_KEY",               "valueFrom": aws_ssm_parameter.identity_cloak_key.arn }
      ]
      "environment": [
        { "name": "PORT",                    "value": "4000" },
        { "name": "IS_WORKER",               "value": "true" },
        { "name": "IS_RABBITMQ_SUBCSCRIBER", "value": "false" },
        { "name": "APP_BASE_URL",            "value": "https://${local.subdomain_suffix == "" ? "" : "${local.subdomain_suffix}." }${local.domain}" },
        { "name": "SEND_REAL_EMAILS",        "value": "true" }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "ticketing" {
  family     = "ticketing"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  depends_on = [aws_db_instance.database, aws_elasticache_replication_group.redis]
  container_definitions = jsonencode([
    {
      name      = "ticketing"
      image     = aws_ecr_repository.ticketing.repository_url
      memoryReservation  = local.ticketing_min_memory
      memory             = local.ticketing_max_memory
      cpu                = local.ticketing_cpu
      essential = true
      portMappings = [
        {
          hostPort      = 0
          containerPort = 4000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group":         aws_cloudwatch_log_group.ticketing.name,
          "awslogs-region":        local.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        { "name": "SECRET_KEY_BASE",         "valueFrom": aws_ssm_parameter.ticketing_secret_key_base.arn },
        { "name": "ADMIN_USER",              "valueFrom": aws_ssm_parameter.admin_user.arn },
        { "name": "ADMIN_PASS",              "valueFrom": aws_ssm_parameter.admin_pass.arn },
        { "name": "JWT_HMAC_KEY",            "valueFrom": aws_ssm_parameter.jwt_hmac_key.arn },
        { "name": "POSTGRES_CA_CERT_PATH",   "valueFrom": aws_ssm_parameter.postgres_ca_cert_path.arn },
        { "name": "POSTGRES_HOST",           "valueFrom": aws_ssm_parameter.postgres_host.arn },
        { "name": "POSTGRES_PORT",           "valueFrom": aws_ssm_parameter.postgres_port.arn },
        { "name": "POSTGRES_USER",           "valueFrom": aws_ssm_parameter.postgres_user.arn },
        { "name": "POSTGRES_PASS",           "valueFrom": aws_ssm_parameter.postgres_pass.arn },
        { "name": "POSTGRES_DB",             "valueFrom": aws_ssm_parameter.ticketing_db_name.arn },
        { "name": "POSTGRES_POOL_SIZE",      "valueFrom": aws_ssm_parameter.ticketing_db_pool_size.arn },
        { "name": "REDIS_HOST",              "valueFrom": aws_ssm_parameter.redis_host.arn },
        { "name": "REDIS_PORT",              "valueFrom": aws_ssm_parameter.redis_port.arn },
        { "name": "REDIS_DB",                "valueFrom": aws_ssm_parameter.ticketing_redis_db.arn },
        { "name": "RABBITMQ_HOST",           "valueFrom": aws_ssm_parameter.rabbitmq_host.arn },
        { "name": "RABBITMQ_PORT",           "valueFrom": aws_ssm_parameter.rabbitmq_port.arn },
        { "name": "RABBITMQ_USERNAME",       "valueFrom": aws_ssm_parameter.rabbitmq_user.arn },
        { "name": "RABBITMQ_PASSWORD",       "valueFrom": aws_ssm_parameter.rabbitmq_pass.arn },
        { "name": "S3_UPLOAD_BUCKET",        "valueFrom": aws_ssm_parameter.ticketing_s3_upload_bucket.arn },
        { "name": "AWS_ACCESS_KEY_ID",       "valueFrom": aws_ssm_parameter.ticketing_s3_upload_access_key_id.arn },
        { "name": "AWS_SECRET_ACCESS_KEY",   "valueFrom": aws_ssm_parameter.ticketing_s3_upload_secret_access_key.arn },
        { "name": "SENTRY_ENV",              "valueFrom": aws_ssm_parameter.sentry_env.arn },
        { "name": "SENTRY_DSN",              "valueFrom": aws_ssm_parameter.sentry_dsn.arn }
      ],
      "environment": [
        { "name": "PORT",                    "value": "4000" },
        { "name": "IS_WORKER",               "value": "false" },
        { "name": "IS_RABBITMQ_SUBCSCRIBER", "value": "true" },
        { "name": "APP_BASE_URL",            "value": "https://${local.subdomain_suffix == "" ? "" : "${local.subdomain_suffix}." }${local.domain}" },
        { "name": "AWS_REGION",              "value": "us-east-2" }
      ]
    }
  ])
}
resource "aws_ecs_task_definition" "ticketing_worker" {
  family     = "ticketing-worker"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  depends_on = [aws_db_instance.database, aws_elasticache_replication_group.redis]
  container_definitions = jsonencode([
    {
      name      = "ticketing-worker"
      image     = aws_ecr_repository.ticketing.repository_url
      memoryReservation  = local.ticketing_worker_min_memory
      memory             = local.ticketing_worker_max_memory
      cpu                = local.ticketing_worker_cpu
      essential = true
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group":         aws_cloudwatch_log_group.ticketing_worker.name,
          "awslogs-region":        local.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        { "name": "SECRET_KEY_BASE",         "valueFrom": aws_ssm_parameter.ticketing_secret_key_base.arn },
        { "name": "ADMIN_USER",              "valueFrom": aws_ssm_parameter.admin_user.arn },
        { "name": "ADMIN_PASS",              "valueFrom": aws_ssm_parameter.admin_pass.arn },
        { "name": "JWT_HMAC_KEY",            "valueFrom": aws_ssm_parameter.jwt_hmac_key.arn },
        { "name": "POSTGRES_CA_CERT_PATH",   "valueFrom": aws_ssm_parameter.postgres_ca_cert_path.arn },
        { "name": "POSTGRES_HOST",           "valueFrom": aws_ssm_parameter.postgres_host.arn },
        { "name": "POSTGRES_PORT",           "valueFrom": aws_ssm_parameter.postgres_port.arn },
        { "name": "POSTGRES_USER",           "valueFrom": aws_ssm_parameter.postgres_user.arn },
        { "name": "POSTGRES_PASS",           "valueFrom": aws_ssm_parameter.postgres_pass.arn },
        { "name": "POSTGRES_DB",             "valueFrom": aws_ssm_parameter.ticketing_db_name.arn },
        { "name": "POSTGRES_POOL_SIZE",      "valueFrom": aws_ssm_parameter.ticketing_db_pool_size.arn },
        { "name": "REDIS_HOST",              "valueFrom": aws_ssm_parameter.redis_host.arn },
        { "name": "REDIS_PORT",              "valueFrom": aws_ssm_parameter.redis_port.arn },
        { "name": "REDIS_DB",                "valueFrom": aws_ssm_parameter.ticketing_redis_db.arn },
        { "name": "RABBITMQ_HOST",           "valueFrom": aws_ssm_parameter.rabbitmq_host.arn },
        { "name": "RABBITMQ_PORT",           "valueFrom": aws_ssm_parameter.rabbitmq_port.arn },
        { "name": "RABBITMQ_USERNAME",       "valueFrom": aws_ssm_parameter.rabbitmq_user.arn },
        { "name": "RABBITMQ_PASSWORD",       "valueFrom": aws_ssm_parameter.rabbitmq_pass.arn },
        { "name": "S3_UPLOAD_BUCKET",        "valueFrom": aws_ssm_parameter.ticketing_s3_upload_bucket.arn },
        { "name": "AWS_ACCESS_KEY_ID",       "valueFrom": aws_ssm_parameter.ticketing_s3_upload_access_key_id.arn },
        { "name": "AWS_SECRET_ACCESS_KEY",   "valueFrom": aws_ssm_parameter.ticketing_s3_upload_secret_access_key.arn },
        { "name": "SENTRY_ENV",              "valueFrom": aws_ssm_parameter.sentry_env.arn },
        { "name": "SENTRY_DSN",              "valueFrom": aws_ssm_parameter.sentry_dsn.arn }
      ],
      "environment": [
        { "name": "PORT",                    "value": "4000" },
        { "name": "IS_WORKER",               "value": "true" },
        { "name": "IS_RABBITMQ_SUBCSCRIBER", "value": "false" },
        { "name": "APP_BASE_URL",            "value": "https://${local.subdomain_suffix == "" ? "" : "${local.subdomain_suffix}." }${local.domain}" },
        { "name": "AWS_REGION",              "value": "us-east-2" }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "activity" {
  family     = "activity"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  depends_on = [aws_db_instance.database, aws_elasticache_replication_group.redis]
  container_definitions = jsonencode([
    {
      name      = "activity"
      image     = aws_ecr_repository.activity.repository_url
      memoryReservation  = local.activity_min_memory
      memory             = local.activity_max_memory
      cpu                = local.activity_cpu
      essential = true
      portMappings = [
        {
          hostPort      = 0
          containerPort = 4000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group":         aws_cloudwatch_log_group.activity.name,
          "awslogs-region":        local.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        { "name": "SECRET_KEY_BASE",         "valueFrom": aws_ssm_parameter.activity_secret_key_base.arn },
        { "name": "ADMIN_USER",              "valueFrom": aws_ssm_parameter.admin_user.arn },
        { "name": "ADMIN_PASS",              "valueFrom": aws_ssm_parameter.admin_pass.arn },
        { "name": "JWT_HMAC_KEY",            "valueFrom": aws_ssm_parameter.jwt_hmac_key.arn },
        { "name": "POSTGRES_CA_CERT_PATH",   "valueFrom": aws_ssm_parameter.postgres_ca_cert_path.arn },
        { "name": "POSTGRES_HOST",           "valueFrom": aws_ssm_parameter.postgres_host.arn },
        { "name": "POSTGRES_PORT",           "valueFrom": aws_ssm_parameter.postgres_port.arn },
        { "name": "POSTGRES_USER",           "valueFrom": aws_ssm_parameter.postgres_user.arn },
        { "name": "POSTGRES_PASS",           "valueFrom": aws_ssm_parameter.postgres_pass.arn },
        { "name": "POSTGRES_DB",             "valueFrom": aws_ssm_parameter.activity_db_name.arn },
        { "name": "POSTGRES_POOL_SIZE",      "valueFrom": aws_ssm_parameter.activity_db_pool_size.arn },
        { "name": "REDIS_HOST",              "valueFrom": aws_ssm_parameter.redis_host.arn },
        { "name": "REDIS_PORT",              "valueFrom": aws_ssm_parameter.redis_port.arn },
        { "name": "REDIS_DB",                "valueFrom": aws_ssm_parameter.activity_redis_db.arn },
        { "name": "RABBITMQ_HOST",           "valueFrom": aws_ssm_parameter.rabbitmq_host.arn },
        { "name": "RABBITMQ_PORT",           "valueFrom": aws_ssm_parameter.rabbitmq_port.arn },
        { "name": "RABBITMQ_USERNAME",       "valueFrom": aws_ssm_parameter.rabbitmq_user.arn },
        { "name": "RABBITMQ_PASSWORD",       "valueFrom": aws_ssm_parameter.rabbitmq_pass.arn },
        { "name": "SENTRY_ENV",              "valueFrom": aws_ssm_parameter.sentry_env.arn },
        { "name": "SENTRY_DSN",              "valueFrom": aws_ssm_parameter.sentry_dsn.arn }
      ],
      "environment": [
        { "name": "PORT",                    "value": "4000" },
        { "name": "IS_WORKER",               "value": "false" },
        { "name": "IS_RABBITMQ_SUBCSCRIBER", "value": "true" },
      ]
    }
  ])
}
resource "aws_ecs_task_definition" "activity_worker" {
  family     = "activity-worker"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  depends_on = [aws_db_instance.database, aws_elasticache_replication_group.redis]
  container_definitions = jsonencode([
    {
      name      = "activity-worker"
      image     = aws_ecr_repository.activity.repository_url
      memoryReservation  = local.activity_worker_min_memory
      memory             = local.activity_worker_max_memory
      cpu                = local.activity_worker_cpu
      essential = true
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group":         aws_cloudwatch_log_group.activity_worker.name,
          "awslogs-region":        local.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        { "name": "SECRET_KEY_BASE",         "valueFrom": aws_ssm_parameter.activity_secret_key_base.arn },
        { "name": "ADMIN_USER",              "valueFrom": aws_ssm_parameter.admin_user.arn },
        { "name": "ADMIN_PASS",              "valueFrom": aws_ssm_parameter.admin_pass.arn },
        { "name": "JWT_HMAC_KEY",            "valueFrom": aws_ssm_parameter.jwt_hmac_key.arn },
        { "name": "POSTGRES_CA_CERT_PATH",   "valueFrom": aws_ssm_parameter.postgres_ca_cert_path.arn },
        { "name": "POSTGRES_HOST",           "valueFrom": aws_ssm_parameter.postgres_host.arn },
        { "name": "POSTGRES_PORT",           "valueFrom": aws_ssm_parameter.postgres_port.arn },
        { "name": "POSTGRES_USER",           "valueFrom": aws_ssm_parameter.postgres_user.arn },
        { "name": "POSTGRES_PASS",           "valueFrom": aws_ssm_parameter.postgres_pass.arn },
        { "name": "POSTGRES_DB",             "valueFrom": aws_ssm_parameter.activity_db_name.arn },
        { "name": "POSTGRES_POOL_SIZE",      "valueFrom": aws_ssm_parameter.activity_db_pool_size.arn },
        { "name": "REDIS_HOST",              "valueFrom": aws_ssm_parameter.redis_host.arn },
        { "name": "REDIS_PORT",              "valueFrom": aws_ssm_parameter.redis_port.arn },
        { "name": "REDIS_DB",                "valueFrom": aws_ssm_parameter.activity_redis_db.arn },
        { "name": "RABBITMQ_HOST",           "valueFrom": aws_ssm_parameter.rabbitmq_host.arn },
        { "name": "RABBITMQ_PORT",           "valueFrom": aws_ssm_parameter.rabbitmq_port.arn },
        { "name": "RABBITMQ_USERNAME",       "valueFrom": aws_ssm_parameter.rabbitmq_user.arn },
        { "name": "RABBITMQ_PASSWORD",       "valueFrom": aws_ssm_parameter.rabbitmq_pass.arn },
        { "name": "SENTRY_ENV",              "valueFrom": aws_ssm_parameter.sentry_env.arn },
        { "name": "SENTRY_DSN",              "valueFrom": aws_ssm_parameter.sentry_dsn.arn }
      ],
      "environment": [
        { "name": "PORT",                    "value": "4000" },
        { "name": "IS_WORKER",               "value": "true" },
        { "name": "IS_RABBITMQ_SUBCSCRIBER", "value": "false" },
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "coding" {
  family     = "coding"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  depends_on = [aws_db_instance.database, aws_elasticache_replication_group.redis]
  container_definitions = jsonencode([
    {
      name      = "coding"
      image     = aws_ecr_repository.coding.repository_url
      memoryReservation  = local.coding_min_memory
      memory             = local.coding_max_memory
      cpu                = local.coding_cpu
      essential = true
      portMappings = [
        {
          hostPort      = 0
          containerPort = 4000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group":         aws_cloudwatch_log_group.coding.name,
          "awslogs-region":        local.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        { "name": "SECRET_KEY_BASE",           "valueFrom": aws_ssm_parameter.coding_secret_key_base.arn },
        { "name": "ADMIN_USER",                "valueFrom": aws_ssm_parameter.admin_user.arn },
        { "name": "ADMIN_PASS",                "valueFrom": aws_ssm_parameter.admin_pass.arn },
        { "name": "JWT_HMAC_KEY",              "valueFrom": aws_ssm_parameter.jwt_hmac_key.arn },
        { "name": "POSTGRES_CA_CERT_PATH",   "valueFrom": aws_ssm_parameter.postgres_ca_cert_path.arn },
        { "name": "POSTGRES_HOST",             "valueFrom": aws_ssm_parameter.postgres_host.arn },
        { "name": "POSTGRES_PORT",             "valueFrom": aws_ssm_parameter.postgres_port.arn },
        { "name": "POSTGRES_USER",             "valueFrom": aws_ssm_parameter.postgres_user.arn },
        { "name": "POSTGRES_PASS",             "valueFrom": aws_ssm_parameter.postgres_pass.arn },
        { "name": "POSTGRES_DB",               "valueFrom": aws_ssm_parameter.coding_db_name.arn },
        { "name": "POSTGRES_POOL_SIZE",        "valueFrom": aws_ssm_parameter.coding_db_pool_size.arn },
        { "name": "REDIS_HOST",                "valueFrom": aws_ssm_parameter.redis_host.arn },
        { "name": "REDIS_PORT",                "valueFrom": aws_ssm_parameter.redis_port.arn },
        { "name": "REDIS_DB",                  "valueFrom": aws_ssm_parameter.coding_redis_db.arn },
        { "name": "RABBITMQ_HOST",             "valueFrom": aws_ssm_parameter.rabbitmq_host.arn },
        { "name": "RABBITMQ_PORT",             "valueFrom": aws_ssm_parameter.rabbitmq_port.arn },
        { "name": "RABBITMQ_USERNAME",         "valueFrom": aws_ssm_parameter.rabbitmq_user.arn },
        { "name": "RABBITMQ_PASSWORD",         "valueFrom": aws_ssm_parameter.rabbitmq_pass.arn },
        { "name": "SENTRY_ENV",                "valueFrom": aws_ssm_parameter.sentry_env.arn },
        { "name": "SENTRY_DSN",                "valueFrom": aws_ssm_parameter.sentry_dsn.arn },
        { "name": "GITHUB_APP_ID",             "valueFrom": aws_ssm_parameter.coding_github_app_id.arn },
        { "name": "GITHUB_APP_CLIENT_ID",      "valueFrom": aws_ssm_parameter.coding_github_app_client_id.arn },
        { "name": "GITHUB_APP_CLIENT_SECRET",  "valueFrom": aws_ssm_parameter.coding_github_app_client_secret.arn },
        { "name": "GITHUB_APP_SIGNING_SECRET", "valueFrom": aws_ssm_parameter.coding_github_app_signing_secret.arn },
        { "name": "GITHUB_APP_PRIVATE_KEY",    "valueFrom": aws_ssm_parameter.coding_github_app_private_key.arn },
        { "name": "OPENAI_API_KEY",            "valueFrom": aws_ssm_parameter.coding_openai_api_key.arn },
        { "name": "OPENAI_ORG_KEY",            "valueFrom": aws_ssm_parameter.coding_openai_org_key.arn }
      ],
      "environment": [
        { "name": "PORT",                    "value": "4000" },
        { "name": "IS_WORKER",               "value": "false" },
        { "name": "IS_RABBITMQ_SUBCSCRIBER", "value": "true" },
      ]
    }
  ])
}
resource "aws_ecs_task_definition" "coding_worker" {
  family     = "coding-worker"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  depends_on = [aws_db_instance.database, aws_elasticache_replication_group.redis]
  container_definitions = jsonencode([
    {
      name      = "coding-worker"
      image     = aws_ecr_repository.coding.repository_url
      memoryReservation  = local.coding_worker_min_memory
      memory             = local.coding_worker_max_memory
      cpu                = local.coding_worker_cpu
      essential = true
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group":         aws_cloudwatch_log_group.coding_worker.name,
          "awslogs-region":        local.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      "secrets": [
        { "name": "SECRET_KEY_BASE",           "valueFrom": aws_ssm_parameter.coding_secret_key_base.arn },
        { "name": "ADMIN_USER",                "valueFrom": aws_ssm_parameter.admin_user.arn },
        { "name": "ADMIN_PASS",                "valueFrom": aws_ssm_parameter.admin_pass.arn },
        { "name": "JWT_HMAC_KEY",              "valueFrom": aws_ssm_parameter.jwt_hmac_key.arn },
        { "name": "POSTGRES_CA_CERT_PATH",     "valueFrom": aws_ssm_parameter.postgres_ca_cert_path.arn },
        { "name": "POSTGRES_HOST",             "valueFrom": aws_ssm_parameter.postgres_host.arn },
        { "name": "POSTGRES_PORT",             "valueFrom": aws_ssm_parameter.postgres_port.arn },
        { "name": "POSTGRES_USER",             "valueFrom": aws_ssm_parameter.postgres_user.arn },
        { "name": "POSTGRES_PASS",             "valueFrom": aws_ssm_parameter.postgres_pass.arn },
        { "name": "POSTGRES_DB",               "valueFrom": aws_ssm_parameter.coding_db_name.arn },
        { "name": "POSTGRES_POOL_SIZE",        "valueFrom": aws_ssm_parameter.coding_db_pool_size.arn },
        { "name": "REDIS_HOST",                "valueFrom": aws_ssm_parameter.redis_host.arn },
        { "name": "REDIS_PORT",                "valueFrom": aws_ssm_parameter.redis_port.arn },
        { "name": "REDIS_DB",                  "valueFrom": aws_ssm_parameter.coding_redis_db.arn },
        { "name": "RABBITMQ_HOST",             "valueFrom": aws_ssm_parameter.rabbitmq_host.arn },
        { "name": "RABBITMQ_PORT",             "valueFrom": aws_ssm_parameter.rabbitmq_port.arn },
        { "name": "RABBITMQ_USERNAME",         "valueFrom": aws_ssm_parameter.rabbitmq_user.arn },
        { "name": "RABBITMQ_PASSWORD",         "valueFrom": aws_ssm_parameter.rabbitmq_pass.arn },
        { "name": "SENTRY_ENV",                "valueFrom": aws_ssm_parameter.sentry_env.arn },
        { "name": "SENTRY_DSN",                "valueFrom": aws_ssm_parameter.sentry_dsn.arn },
        { "name": "GITHUB_APP_ID",             "valueFrom": aws_ssm_parameter.coding_github_app_id.arn },
        { "name": "GITHUB_APP_CLIENT_ID",      "valueFrom": aws_ssm_parameter.coding_github_app_client_id.arn },
        { "name": "GITHUB_APP_CLIENT_SECRET",  "valueFrom": aws_ssm_parameter.coding_github_app_client_secret.arn },
        { "name": "GITHUB_APP_SIGNING_SECRET", "valueFrom": aws_ssm_parameter.coding_github_app_signing_secret.arn },
        { "name": "GITHUB_APP_PRIVATE_KEY",    "valueFrom": aws_ssm_parameter.coding_github_app_private_key.arn },
        { "name": "OPENAI_API_KEY",            "valueFrom": aws_ssm_parameter.coding_openai_api_key.arn },
        { "name": "OPENAI_ORG_KEY",            "valueFrom": aws_ssm_parameter.coding_openai_org_key.arn }
      ],
      "environment": [
        { "name": "PORT",                    "value": "4000" },
        { "name": "IS_WORKER",               "value": "true" },
        { "name": "IS_RABBITMQ_SUBCSCRIBER", "value": "false" },
      ]
    }
  ])
}
