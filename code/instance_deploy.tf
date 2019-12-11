provider "aws" {
  profile    = "default"
  region     = "us-west-2"
}

resource "aws_iam_role" "code-deploy" {
  name = "code-deploy"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.code-deploy.name}"
}

resource "aws_codedeploy_app" "flask" {
  name = "flask"
}

resource "aws_sns_topic" "flask" {
  name = "flask"
}

resource "aws_codedeploy_deployment_group" "flask" {
  app_name              = "${aws_codedeploy_app.flask.name}"
  deployment_group_name = "flask"
  service_role_arn      = "${aws_iam_role.code-deploy.arn}"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "filterkey1"
      type  = "KEY_AND_VALUE"
      value = "filtervalue"
    }

    ec2_tag_filter {
      key   = "filterkey2"
      type  = "KEY_AND_VALUE"
      value = "filtervalue"
    }
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "flask"
    trigger_target_arn = "${aws_sns_topic.flask.arn}"

  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  }
}
