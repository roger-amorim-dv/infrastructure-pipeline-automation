resource "aws_lambda_function" "my_new_application" {
  function_name = "${var.project}-my_new_application"
  role          = aws_iam_role.my_new_application.arn
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  timeout       = 60

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "my_new_application_test" {
  name = "my_new_application-role"

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
