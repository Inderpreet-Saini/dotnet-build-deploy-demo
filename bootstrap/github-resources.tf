resource "github_actions_secret" "tf_s3_bucket_name" {
  repository       = var.github_repo
  secret_name      = "TF_STATE_BUCKET_NAME"
  plaintext_value  = aws_s3_bucket.tfstate.bucket
}

resource "github_actions_secret" "tf_s3_bucket_key" {
  repository       = var.github_repo
  secret_name      = "TF_STATE_BUCKET_KEY"
  plaintext_value  = "terraform/${var.app_name}.tf"
}

resource "github_actions_secret" "tf_dynamodb_table" {
  repository       = var.github_repo
  secret_name      = "TF_STATE_DYNAMODB_TABLE"
  plaintext_value  = aws_dynamodb_table.tfstate.name
}

resource "github_actions_secret" "github_oidc_role_name" {
  repository       = var.github_repo
  secret_name      = "AWS_OIDC_ROLE_NAME"
  plaintext_value  = aws_iam_role.github_actions.arn
}

resource "github_actions_secret"  "ecr_repo_url" {
   repository  =  var.github_repo
   secret_name = "ECR_REPO_URL"
   plaintext_value = aws_ecr_repository.ecr.repository_url
}