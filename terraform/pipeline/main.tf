resource "aws_codepipeline" "terraform_pipeline" {
  for_each = local.env_list
  name     = "terraform-pipeline-${terraform.workspace}-${each.key}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.s3_artifactory
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "dougpms/training"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name            = "BuildAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = "terraform_build_${terraform.workspace}-${each.key}"

      }
    }
  }
}

resource "aws_codepipeline" "terraform_pipeline_destroy" {
  for_each = local.env_list
  name     = "terraform-pipeline-destroy-${terraform.workspace}-${each.key}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.s3_artifactory
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "dougpms/training"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name            = "BuildAction"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = "terraform_build_${terraform.workspace}-destroy-${each.key}"

      }
    }
  }
}


resource "aws_codestarconnections_connection" "github" {
  name          = "GitHubRepo"
  provider_type = "GitHub"
}