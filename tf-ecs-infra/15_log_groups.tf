resource "aws_cloudwatch_log_group" "webapp" {
  name = "${local.env_name}-webapp"
}

resource "aws_cloudwatch_log_group" "identity" {
  name = "${local.env_name}-identity"
}

resource "aws_cloudwatch_log_group" "identity_worker" {
  name = "${local.env_name}-identity-worker"
}

resource "aws_cloudwatch_log_group" "ticketing" {
  name = "${local.env_name}-ticketing"
}

resource "aws_cloudwatch_log_group" "ticketing_worker" {
  name = "${local.env_name}-ticketing-worker"
}

resource "aws_cloudwatch_log_group" "activity" {
  name = "${local.env_name}-activity"
}

resource "aws_cloudwatch_log_group" "activity_worker" {
  name = "${local.env_name}-activity-worker"
}

resource "aws_cloudwatch_log_group" "coding" {
  name = "${local.env_name}-coding"
}

resource "aws_cloudwatch_log_group" "coding_worker" {
  name = "${local.env_name}-coding-worker"
}