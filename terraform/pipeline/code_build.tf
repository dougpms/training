resource "aws_codebuild_project" "terraform_build" {
  name = "terraform_build_${terraform.workspace}"
  service_role = aws_iam_role.codebuild_role.arn
  build_timeout = var.timeout
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/dougpms/training.git"
    git_clone_depth = 1
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
  buildspec = file("terraform/pipeline/templates/buildspec.yml")
}