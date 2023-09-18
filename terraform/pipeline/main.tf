## Creates ECR repo for potential use
#module "ecr" {
#  source = "../ecr"
#}

# Code build part
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
}


#resource "aws_codepipeline" "terraform_pipeline" {
#  name = "terraform-pipeline"
#  role_arn = aws_iam_role.codebuild_role.arn
#
#  artifact_store {
#    location = var.s3_artifactory
#    type     = "S3"
#  }
#
#  stage {
#    name = "Source"
#    action {
#      name            = "SourceAction"
#      category        = "Source"
#      owner           = "ThirdParty"
#      provider        = "GitHub"
#      version         = "1"
#      output_artifacts = ["source_output"]
#
#      configuration = {
#        Owner  = "yourusername"
#        Repo   = "yourrepository"
#        Branch = "main"
#        OAuthToken = "YOUR_GITHUB_OAUTH_TOKEN"
#      }
#    }
#  }
#
#  stage {
#    name = "Build"
#    action {
#      name            = "BuildAction"
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      version         = "1"
#      input_artifacts = ["source_output"]
#
#      configuration = {
#        ProjectName = aws_codebuild_project.terraform_build.name
#      }
#    }
#  }
#}
