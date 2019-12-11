provider "aws" {
  profile    = "default"
  region     = "us-west-2"
}

resource "aws_s3_bucket" "codeholder" {
  bucket = "codeholder"
  acl    = "private"
}


resource "aws_codebuild_project" "codebuild" {
  name = "${var.github_repository}"
  build_timeout  = "5"
  service_role   = "arn:aws:iam::436626026956:role/service-role/codebuild-flaskapp-service-role"


  source {
    type      = "CODECOMMIT"
    location  = "${var.repo}"
    buildspec = "${var.buildspec}"

  }

  cache {
    type     = "S3"
    location = "${aws_s3_bucket.codeholder.bucket}"
  }

  environment {
    compute_type         = "${var.codebuild_compute_type}"
    type                 = "LINUX_CONTAINER"
    image                = "${var.codebuild_image}"
    privileged_mode      = "${var.codebuild_privileged_mode}"
  }

  artifacts {
    type           = "S3"
    name           = "${var.github_repository}"
    location       = "codeholder"
    namespace_type = "BUILD_ID"
    packaging      = "ZIP"
  }

}
