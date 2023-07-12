resource "aws_lambda_function" "application_name" {
  function_name = "${var.project}-my_application_name"
  role          = aws_iam_role.application_name.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  timeout       = 60

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "application_name" {
  name = "${var.project}-my_application_name-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}
