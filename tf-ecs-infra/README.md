- Use different aws account per stage: prod account, staging accounts
- Make an IAM user named `github-action` and add AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY in https://github.com/<org>/<repo>/settings/secrets/actions
- Store your terraform state in s3 bucket and use dynamodb for locking:
  - make an s3 bucket (enable versioning and encryption for it)
  - make a dynamodb table with hash_key of "LockID" and "On demand" capacity
  - add backend block to terraform script:
  ```
  terraform {
    backend "s3" {
      bucket         = "your-bucket-name"
      region         = "us-east-2"
      key            = "global/s3/terraform.tfstate"
      dynamodb_table = "your-dynamo-db-name"
      encrypt        = true
    }
  }
  ```
- Go to ec2 keypairs, create one keypair with the name set according to `keypair_name` in locals.tf
- Go to route53, create a hosted zone for the domain it gives you dns nameserver addresses to put in namecheap
- Go to aws Certificate Manager and request a public certificate for addresses `domain.com` and `*.domain.com`, copy the certificate arn to locals.tf
- Make sure you click create records in route 53 for the certificate to verify domain ownership
- Go to AWS IAM, make a user for terraform, with administration access, set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in zshrc.
- Check if aws cli connection is working: `aws sts get-caller-identity`
- Run `terraform init`
- Run `terraform apply`

  - Ref: https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa

# Setup Slack App
- Goto https://api.slack.com/apps
- Customize the example manifest in `slack-app-manifest.json`
- Create a new app using this manifest
# Spin up a new environment
- Clone terraform/staging directory and rename it to anything you want
- Delete `.terraform.lock.hcl` and `.terraform` directory in your new cloned directory
- Customize `init.tf` and `locals.tf`
- Make sure there is a `secrets.auto.tfvars` in the directory. Customize values inside.
