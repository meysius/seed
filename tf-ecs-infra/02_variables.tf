# Shared variables
variable "admin_user"               {}
variable "admin_pass"               {}
variable "postgres_ca_cert_path"    {}
variable "postgres_user"            {}
variable "postgres_pass"            {}
variable "postgres_port"            {}
variable "redis_port"               {}
variable "jwt_hmac_key"             {}
variable "google_client_id"         {}
variable "rabbitmq_port"            {}
variable "rabbitmq_admin_user"      {}
variable "rabbitmq_admin_pass"      {}
variable "rabbitmq_user"            {}
variable "rabbitmq_pass"            {}
variable "sentry_env"               {}
variable "sentry_dsn"               {}
variable "slack_client_id"          {}

# Webapp variables
variable "webapp_stripe_public_key"   {}
variable "webapp_github_app_name"     {}
variable "webapp_posthog_key"         {}

# Identity variables
variable "identity_secret_key_base" {}
variable "identity_db_name"         {}
variable "identity_db_pool_size"    {}
variable "identity_redis_db"        {}
variable "stripe_secret_key"        {}
variable "identity_slack_client_secret"  {}
variable "identity_slack_signing_secret" {}
variable "identity_cloak_key"            {}

# Ticketing variables
variable "ticketing_secret_key_base" {}
variable "ticketing_db_name"         {}
variable "ticketing_db_pool_size"    {}
variable "ticketing_redis_db"        {}

# Activity variables
variable "activity_secret_key_base" {}
variable "activity_db_name"         {}
variable "activity_db_pool_size"    {}
variable "activity_redis_db"        {}

# Coding variables
variable "coding_secret_key_base"           {}
variable "coding_db_name"                   {}
variable "coding_db_pool_size"              {}
variable "coding_redis_db"                  {}
variable "coding_github_app_id"             {}
variable "coding_github_app_client_id"      {}
variable "coding_github_app_client_secret"  {}
variable "coding_github_app_signing_secret" {}
variable "coding_github_app_private_key"    {}
variable "coding_openai_api_key"            {}
variable "coding_openai_org_key"            {}


resource "aws_ssm_parameter" "admin_user" {
  name  = "/${local.env_name}/shared/admin_user"
  type  = "SecureString"
  value = var.admin_user
}

resource "aws_ssm_parameter" "admin_pass" {
  name  = "/${local.env_name}/shared/admin_pass"
  type  = "SecureString"
  value = var.admin_pass
}

resource "aws_ssm_parameter" "postgres_ca_cert_path" {
  name = "/${local.env_name}/shared/postgres_ca_cert_path"
  type = "SecureString"
  value = var.postgres_ca_cert_path
}

resource "aws_ssm_parameter" "postgres_host" {
  name  = "/${local.env_name}/shared/postgres_host"
  type  = "SecureString"
  value = aws_db_instance.database.address
}

resource "aws_ssm_parameter" "postgres_user" {
  name  = "/${local.env_name}/shared/postgres_user"
  type  = "SecureString"
  value = var.postgres_user
}

resource "aws_ssm_parameter" "postgres_pass" {
  name  = "/${local.env_name}/shared/postgres_pass"
  type  = "SecureString"
  value = var.postgres_pass
}

resource "aws_ssm_parameter" "postgres_port" {
  name  = "/${local.env_name}/shared/postgres_port"
  type  = "SecureString"
  value = var.postgres_port
}

resource "aws_ssm_parameter" "redis_host" {
  name  = "/${local.env_name}/shared/redis_host"
  type  = "SecureString"
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

resource "aws_ssm_parameter" "redis_port" {
  name  = "/${local.env_name}/shared/redis_port"
  type  = "SecureString"
  value = var.redis_port
}

resource "aws_ssm_parameter" "jwt_hmac_key" {
  name  = "/${local.env_name}/shared/jwt_hmac_key"
  type  = "SecureString"
  value = var.jwt_hmac_key
}

resource "aws_ssm_parameter" "google_client_id" {
  name  = "/${local.env_name}/shared/google_client_id"
  type  = "SecureString"
  value = var.google_client_id
}

resource "aws_ssm_parameter" "rabbitmq_host" {
  name  = "/${local.env_name}/shared/rabbitmq_host"
  type  = "SecureString"
  value = aws_instance.rabbitmq.private_dns
}

resource "aws_ssm_parameter" "rabbitmq_port" {
  name  = "/${local.env_name}/shared/rabbitmq_port"
  type  = "SecureString"
  value = var.rabbitmq_port
}

resource "aws_ssm_parameter" "rabbitmq_admin_user" {
  name  = "/${local.env_name}/shared/rabbitmq_admin_user"
  type  = "SecureString"
  value = var.rabbitmq_admin_user
}

resource "aws_ssm_parameter" "rabbitmq_admin_pass" {
  name  = "/${local.env_name}/shared/rabbitmq_admin_pass"
  type  = "SecureString"
  value = var.rabbitmq_admin_pass
}

resource "aws_ssm_parameter" "rabbitmq_user" {
  name  = "/${local.env_name}/shared/rabbitmq_user"
  type  = "SecureString"
  value = var.rabbitmq_user
}

resource "aws_ssm_parameter" "rabbitmq_pass" {
  name  = "/${local.env_name}/shared/rabbitmq_pass"
  type  = "SecureString"
  value = var.rabbitmq_pass
}

resource "aws_ssm_parameter" "sentry_env" {
  name  = "/${local.env_name}/shared/sentry_env"
  type  = "SecureString"
  value = var.sentry_env
}

resource "aws_ssm_parameter" "sentry_dsn" {
  name  = "/${local.env_name}/shared/sentry_dsn"
  type  = "SecureString"
  value = var.sentry_dsn
}

resource "aws_ssm_parameter" "slack_client_id" {
  name  = "/${local.env_name}/shared/slack_client_id"
  type  = "SecureString"
  value = var.slack_client_id
}

resource "aws_ssm_parameter" "webapp_stripe_public_key" {
  name  = "/${local.env_name}/webapp/stripe_public_key"
  type  = "SecureString"
  value = var.webapp_stripe_public_key
}

resource "aws_ssm_parameter" "webapp_github_app_name" {
  name  = "/${local.env_name}/webapp/github_app_name"
  type  = "SecureString"
  value = var.webapp_github_app_name
}

resource "aws_ssm_parameter" "webapp_posthog_key" {
  name  = "/${local.env_name}/webapp/webapp_posthog_key"
  type  = "SecureString"
  value = var.webapp_posthog_key
}

resource "aws_ssm_parameter" "identity_secret_key_base" {
  name  = "/${local.env_name}/identity/secret_key_base"
  type  = "SecureString"
  value = var.identity_secret_key_base
}

resource "aws_ssm_parameter" "identity_db_name" {
  name  = "/${local.env_name}/identity/db_name"
  type  = "SecureString"
  value = var.identity_db_name
}

resource "aws_ssm_parameter" "identity_db_pool_size" {
  name  = "/${local.env_name}/identity/db_pool_size"
  type  = "SecureString"
  value = var.identity_db_pool_size
}

resource "aws_ssm_parameter" "identity_redis_db" {
  name  = "/${local.env_name}/identity/redis_db"
  type  = "SecureString"
  value = var.identity_redis_db
}

resource "aws_ssm_parameter" "stripe_secret_key" {
  name  = "/${local.env_name}/identity/stripe_secret_key"
  type  = "SecureString"
  value = var.stripe_secret_key
}

resource "aws_ssm_parameter" "identity_ses_access_key_id" {
  name  = "/${local.env_name}/identity/ses_access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.ses.id
}

resource "aws_ssm_parameter" "identity_ses_secret_access_key" {
  name  = "/${local.env_name}/identity/ses_secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.ses.secret
}

resource "aws_ssm_parameter" "identity_mail_from_domain" {
  name  = "/${local.env_name}/identity/mail_from_domain"
  type  = "SecureString"
  value = aws_ses_domain_mail_from.mail_from.mail_from_domain
}

resource "aws_ssm_parameter" "identity_slack_client_secret" {
  name  = "/${local.env_name}/identity/slack_client_secret"
  type  = "SecureString"
  value = var.identity_slack_client_secret
}

resource "aws_ssm_parameter" "identity_slack_signing_secret" {
  name  = "/${local.env_name}/identity/slack_signing_secret"
  type  = "SecureString"
  value = var.identity_slack_signing_secret
}

resource "aws_ssm_parameter" "identity_cloak_key" {
  name  = "/${local.env_name}/identity/cloak_key"
  type  = "SecureString"
  value = var.identity_cloak_key
}

resource "aws_ssm_parameter" "ticketing_secret_key_base" {
  name  = "/${local.env_name}/ticketing/secret_key_base"
  type  = "SecureString"
  value = var.ticketing_secret_key_base
}

resource "aws_ssm_parameter" "ticketing_db_name" {
  name  = "/${local.env_name}/ticketing/db_name"
  type  = "SecureString"
  value = var.ticketing_db_name
}

resource "aws_ssm_parameter" "ticketing_db_pool_size" {
  name  = "/${local.env_name}/ticketing/db_pool_size"
  type  = "SecureString"
  value = var.ticketing_db_pool_size
}

resource "aws_ssm_parameter" "ticketing_redis_db" {
  name  = "/${local.env_name}/ticketing/redis_db"
  type  = "SecureString"
  value = var.ticketing_redis_db
}

resource "aws_ssm_parameter" "ticketing_s3_upload_bucket" {
  name  = "/${local.env_name}/ticketing/s3_upload_bucket"
  type  = "SecureString"
  value = aws_s3_bucket.uploads.bucket
}

resource "aws_ssm_parameter" "ticketing_s3_upload_access_key_id" {
  name  = "/${local.env_name}/ticketing/s3_upload_access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.uploads_s3.id
}

resource "aws_ssm_parameter" "ticketing_s3_upload_secret_access_key" {
  name  = "/${local.env_name}/ticketing/s3_upload_secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.uploads_s3.secret
}

resource "aws_ssm_parameter" "activity_secret_key_base" {
  name  = "/${local.env_name}/activity/secret_key_base"
  type  = "SecureString"
  value = var.activity_secret_key_base
}

resource "aws_ssm_parameter" "activity_db_name" {
  name  = "/${local.env_name}/activity/db_name"
  type  = "SecureString"
  value = var.activity_db_name
}

resource "aws_ssm_parameter" "activity_db_pool_size" {
  name  = "/${local.env_name}/activity/db_pool_size"
  type  = "SecureString"
  value = var.activity_db_pool_size
}

resource "aws_ssm_parameter" "activity_redis_db" {
  name  = "/${local.env_name}/activity/redis_db"
  type  = "SecureString"
  value = var.activity_redis_db
}

resource "aws_ssm_parameter" "coding_secret_key_base" {
  name  = "/${local.env_name}/coding/secret_key_base"
  type  = "SecureString"
  value = var.coding_secret_key_base
}

resource "aws_ssm_parameter" "coding_db_name" {
  name  = "/${local.env_name}/coding/db_name"
  type  = "SecureString"
  value = var.coding_db_name
}

resource "aws_ssm_parameter" "coding_db_pool_size" {
  name  = "/${local.env_name}/coding/db_pool_size"
  type  = "SecureString"
  value = var.coding_db_pool_size
}

resource "aws_ssm_parameter" "coding_redis_db" {
  name  = "/${local.env_name}/coding/redis_db"
  type  = "SecureString"
  value = var.coding_redis_db
}

resource "aws_ssm_parameter" "coding_github_app_id" {
  name = "/${local.env_name}/coding/github_app_id"
  type = "SecureString"
  value = var.coding_github_app_id
}

resource "aws_ssm_parameter" "coding_github_app_client_id" {
  name = "/${local.env_name}/coding/github_app_client_id"
  type = "SecureString"
  value = var.coding_github_app_client_id
}

resource "aws_ssm_parameter" "coding_github_app_client_secret" {
  name = "/${local.env_name}/coding/github_app_client_secret"
  type = "SecureString"
  value = var.coding_github_app_client_secret
}

resource "aws_ssm_parameter" "coding_github_app_signing_secret" {
  name = "/${local.env_name}/coding/github_app_signing_secret"
  type = "SecureString"
  value = var.coding_github_app_signing_secret
}

resource "aws_ssm_parameter" "coding_github_app_private_key" {
  name = "/${local.env_name}/coding/github_app_private_key"
  type = "SecureString"
  value = var.coding_github_app_private_key
}

resource "aws_ssm_parameter" "coding_openai_api_key" {
  name = "/${local.env_name}/coding/openai_api_key"
  type = "SecureString"
  value = var.coding_openai_api_key
}

resource "aws_ssm_parameter" "coding_openai_org_key" {
  name = "/${local.env_name}/coding/openai_org_key"
  type = "SecureString"
  value = var.coding_openai_org_key
}