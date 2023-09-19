## Creates ECR repo for potential use
#module "ecr" {
#  source = "../ecr"
#}

resource "aws_codepipeline" "terraform_pipeline" {
  name = "terraform-pipeline"
  role_arn = aws_iam_role.codebuild_role.arn

  artifact_store {
    location = var.s3_artifactory
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name            = "SourceAction"
      category        = "Source"
      owner           = "ThirdParty"
      provider        = "GitHub"
      version         = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "dougpms"
        Repo       = "training"
        Branch     = "main"  # Replace with your desired branch
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
        ProjectName = aws_codebuild_project.terraform_build.name
      }
    }
  }
}
