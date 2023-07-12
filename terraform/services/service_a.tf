resource "aws_lambda_function" "application_a" {
  function_name = "my-application-a"
  role          = aws_iam_role.main.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  timeout       = 60

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "main" {
  name = "test-application-a-role"

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