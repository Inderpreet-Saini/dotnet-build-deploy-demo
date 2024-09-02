
# GitHub OIDC Configuration 
# https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

# Fetch latest TLS cert from GitHub to authenticate requests
data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

# IAM policy to allow assume role
data "aws_iam_policy_document" "ghaassumerole" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["${aws_iam_openid_connect_provider.github_actions.arn}"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}

# IAM policy allowing Github to create and manage AWS resources
data "aws_iam_policy_document" "TerraformState" {
  # Terraform state Amazon S3 access
  statement {
    actions   = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]
    resources = [
      "${aws_s3_bucket.tfstate.arn}",
      "${aws_s3_bucket.tfstate.arn}/*"
      ]
  }
  # Terraform state Amazon DynamoDB access
  statement {
    actions   = [
      "dynamodb:BatchGetItem",
      "dynamodb:Query",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:List*"
    ]
    resources = [
      "${aws_dynamodb_table.tfstate.arn}"
      ]
  }
}

# Create OIDC Provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

# Define IAM Role configured for assuming the role with web identity, tailored for GitHub Actions
resource "aws_iam_role" "github_actions" {
  name               = "github-actions"
  assume_role_policy = data.aws_iam_policy_document.ghaassumerole.json

    inline_policy {
    name   = "tf-state-mgmt-policy"
    policy = data.aws_iam_policy_document.TerraformState.json
  }
    inline_policy {
    name   = "myfavouriteplaces-dotnet-app"
    policy = data.aws_iam_policy_document.SampleApp.json
  }

  tags = local.common_tags
}

# Outputs used to create GitHub resources
output "gha_iam_role" {
  value = aws_iam_role.github_actions.arn
}
output "tfstate_bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}
output "tfstate_dynamodb_table_name" {
  value = aws_dynamodb_table.tfstate.name
}