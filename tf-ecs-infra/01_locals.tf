
locals {
  env_name            = "prod"
  aws_account_id      = "..."
  region              = "us-east-2"  # dont use us-east-1 as it is crappiest region with most incidents and outages

  vpc_subnets = {
    us-east-2a = "10.0.1.0/24"
    us-east-2b = "10.0.2.0/24"
    us-east-2c = "10.0.3.0/24"
  }

  db_instance_type              = "db.t3.micro"
  db_allocated_storage          = 20
  db_max_allocated_storage      = 1000
  db_deletion_protection        = true
  db_multi_az                   = false
  db_skip_final_snapshot        = false

  redis_instance_type           = "cache.t3.micro"

  rabbitmq_instance_size        = "t3.micro"

  # Requires users below to already exist in the aws account
  # You only need 1 user if you have monorepo
  gh_actions_iam_user           = "github-actions"
  webapp_gh_actions_iam_user    = "webapp-github-actions"
  identity_gh_actions_iam_user  = "identity-github-actions"
  ticketing_gh_actions_iam_user = "ticketing-github-actions"
  activity_gh_actions_iam_user  = "activity-github-actions"
  coding_gh_actions_iam_user    = "coding-github-actions"

  keypair_name                  = "pacely_prod"             # Requires an existing aws keypair
  domain                        = "pacely.dev"              # Requires an existing hosted zone in route53
  ses_identity_domain           = "pacely.dev"              # mail.XXX
  subdomain_suffix              = ""                        # appXXX.exapmle.com
  ssl_certificate_arn           = "..."
  ecs_ec2_ami                   = "ami-0de5ed5b8d5233741"

  t3_micro_fleet_min_instances  = 0
  t3_micro_fleet_max_instances  = 20

  t3_small_fleet_min_instances  = 0
  t3_small_fleet_max_instances  = 10

  min_health_percentage         = 100
  max_health_percentage         = 200

  webapp_min_tasks                     = 1
  webapp_max_tasks                     = 5
  webapp_cpu_scaling_target            = 70
  webapp_mem_scaling_target            = 70
  webapp_scale_up_cooldown             = 300
  webapp_scale_down_cooldown           = 300
  webapp_cpu                           = 975
  webapp_min_memory                    = 450
  webapp_max_memory                    = 450

  identity_min_tasks                   = 1
  identity_max_tasks                   = 5
  identity_cpu_scaling_target          = 70
  identity_mem_scaling_target          = 70
  identity_scale_up_cooldown           = 300
  identity_scale_down_cooldown         = 300
  identity_cpu                         = 975
  identity_min_memory                  = 450
  identity_max_memory                  = 450

  identity_worker_min_tasks            = 1
  identity_worker_max_tasks            = 5
  identity_worker_cpu_scaling_target   = 70
  identity_worker_mem_scaling_target   = 70
  identity_worker_scale_up_cooldown    = 300
  identity_worker_scale_down_cooldown  = 300
  identity_worker_cpu                  = 975
  identity_worker_min_memory           = 450
  identity_worker_max_memory           = 450

  ticketing_min_tasks                  = 1
  ticketing_max_tasks                  = 1
  ticketing_cpu_scaling_target         = 70
  ticketing_mem_scaling_target         = 70
  ticketing_scale_up_cooldown          = 300
  ticketing_scale_down_cooldown        = 300
  ticketing_cpu                        = 975
  ticketing_min_memory                 = 450
  ticketing_max_memory                 = 450

  ticketing_worker_min_tasks           = 1
  ticketing_worker_max_tasks           = 1
  ticketing_worker_cpu_scaling_target  = 70
  ticketing_worker_mem_scaling_target  = 70
  ticketing_worker_scale_up_cooldown   = 300
  ticketing_worker_scale_down_cooldown = 300
  ticketing_worker_cpu                 = 975
  ticketing_worker_min_memory          = 450
  ticketing_worker_max_memory          = 450

  activity_min_tasks                   = 1
  activity_max_tasks                   = 5
  activity_cpu_scaling_target          = 70
  activity_mem_scaling_target          = 70
  activity_scale_up_cooldown           = 300
  activity_scale_down_cooldown         = 300
  activity_cpu                         = 975
  activity_min_memory                  = 450
  activity_max_memory                  = 450

  activity_worker_min_tasks            = 1
  activity_worker_max_tasks            = 5
  activity_worker_cpu_scaling_target   = 70
  activity_worker_mem_scaling_target   = 70
  activity_worker_scale_up_cooldown    = 300
  activity_worker_scale_down_cooldown  = 300
  activity_worker_cpu                  = 975
  activity_worker_min_memory           = 450
  activity_worker_max_memory           = 450

  coding_min_tasks                     = 1
  coding_max_tasks                     = 5
  coding_cpu_scaling_target            = 70
  coding_mem_scaling_target            = 70
  coding_scale_up_cooldown             = 300
  coding_scale_down_cooldown           = 300
  coding_cpu                           = 975
  coding_min_memory                    = 450
  coding_max_memory                    = 450

  coding_worker_min_tasks              = 1
  coding_worker_max_tasks              = 5
  coding_worker_cpu_scaling_target     = 70
  coding_worker_mem_scaling_target     = 70
  coding_worker_scale_up_cooldown      = 300
  coding_worker_scale_down_cooldown    = 300
  coding_worker_cpu                    = 975
  coding_worker_min_memory             = 450
  coding_worker_max_memory             = 450
}
