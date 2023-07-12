resource "aws_lambda_function" "application_b" {
  function_name = "my-application-b"
  role          = aws_iam_role.main.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  timeout       = 60

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "main" {
  name = "test-application-b-role"

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