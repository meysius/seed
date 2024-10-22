####################################
# Policies
####################################

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_service" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_task_execution" {
  name        = "${local.env_name}-pacely-ecs-task-execution"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ssm:GetParameters"
        Resource = "arn:aws:ssm:${local.region}:${local.aws_account_id}:parameter/${local.env_name}/*"
      },
      {
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ses" {
  name        = "${local.env_name}-pacely-ses"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ses:*"
        Resource = aws_ses_domain_identity.identity.arn
      },
      {
        Effect   = "Allow"
        Action   = "ses:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "uploads_s3" {
  name        = "${local.env_name}-pacely-uploads-s3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [ "s3:PutObject", "s3:GetObject" ]
        Resource = "${aws_s3_bucket.uploads.arn}/*"
      }
    ]
  })
}

resource "aws_iam_policy" "gh_actions" {
  name        = "${local.env_name}-gh-actions"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ecs:UpdateService"
        Resource = [
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:service/pacely/webapp",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:service/pacely/identity",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:service/pacely/ticketing",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:service/pacely/activity",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:service/pacely/coding",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:service/pacely/identity-worker",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:service/pacely/ticketing-worker",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:service/pacely/activity-worker",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:service/pacely/coding-worker"
        ]
      },
      {
        Effect   = "Allow"
        Action   = "ecs:RunTask"
        Resource = [
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:task-definition/webapp",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:task-definition/identity",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:task-definition/ticketing",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:task-definition/activity",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:task-definition/coding",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:task-definition/identity-worker",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:task-definition/ticketing-worker",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:task-definition/activity-worker",
          "arn:aws:ecs:${local.region}:${local.aws_account_id}:task-definition/coding-worker"
        ]
      },
      {
        Effect   = "Allow",
        Action   = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
        ]
        Resource = [
          aws_ecr_repository.webapp.arn,
          aws_ecr_repository.identity.arn,
          aws_ecr_repository.ticketing.arn,
          aws_ecr_repository.activity.arn,
          aws_ecr_repository.coding.arn
        ]
      },
      {
        Effect   = "Allow",
        Action   = [
          "ecr:DescribeImageScanFindings",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetDownloadUrlForLayer",
          "ecr:ListTagsForResource",
          "ecr:UploadLayerPart",
          "ecr:ListImages",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:GetLifecyclePolicy"
        ]
        Resource = [
          aws_ecr_repository.webapp.arn,
          aws_ecr_repository.identity.arn,
          aws_ecr_repository.ticketing.arn,
          aws_ecr_repository.activity.arn,
          aws_ecr_repository.coding.arn
        ]
      },
      {
        Effect   = "Allow"
        Action   = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:DescribeServices",
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["iam:GetRole", "iam:PassRole"],
        Resource = aws_iam_role.ecs_task_execution.arn
      }
    ]
  })
}


####################################
# Users
####################################

resource "aws_iam_user" "ses" {
  name = "${local.env_name}-pacely-ses"
}

resource "aws_iam_user" "uploads_s3" {
  name = "${local.env_name}-pacely-uploads-s3"
}

####################################
# Roles
####################################

resource "aws_iam_role" "ecs_agent" {
  name               = "${local.env_name}-pacely-ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role" "ecs_service" {
  name               = "${local.env_name}-pacely-ecs-service"
  assume_role_policy = data.aws_iam_policy_document.ecs_service.json
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${local.env_name}-pacely-ecs-task-execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution.json
}

####################################
# Instance Profiles
####################################

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "${local.env_name}-pacely-ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

####################################
# Policy Attachments
####################################

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution.arn
}

resource "aws_iam_user_policy_attachment" "ses" {
  user       = aws_iam_user.ses.name
  policy_arn = aws_iam_policy.ses.arn
}

resource "aws_iam_user_policy_attachment" "uploads_s3" {
  user       = aws_iam_user.uploads_s3.name
  policy_arn = aws_iam_policy.uploads_s3.arn
}

resource "aws_iam_user_policy_attachment" "gh_actions" {
  user       = local.gh_actions_iam_user
  policy_arn = aws_iam_policy.gh_actions.arn
}

####################################
# Access Keys
####################################

resource "aws_iam_access_key" "ses" {
  user = aws_iam_user.ses.name
}

resource "aws_iam_access_key" "uploads_s3" {
  user = aws_iam_user.uploads_s3.name
}