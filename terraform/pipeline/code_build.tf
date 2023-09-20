resource "aws_codebuild_project" "terraform_build" {
  for_each      = local.env_list
  name          = "terraform_build_${terraform.workspace}-${each.key}"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = var.timeout
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "PIPE_NAME"
      value = each.key
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "./terraform/pipeline/templates/buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

  resource "aws_codebuild_project" "terraform_destroy" {
  for_each      = local.env_list
  name          = "terraform_build_${terraform.workspace}-destroy-${each.key}"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = var.timeout
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "PIPE_NAME"
      value = each.key
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "./terraform/pipeline/templates/buildspec_destroy.yml"
  }
  artifacts {
    type = "CODEPIPELINE"
  }
}