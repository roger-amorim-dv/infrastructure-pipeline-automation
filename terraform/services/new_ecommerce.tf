resource "aws_lambda_function" "new_ecommerce" {
  function_name = "${var.project}-new_ecommerce"
  role          = aws_iam_role.application_name.arn
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  timeout       = 10

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "new_ecommerce" {
  name = "new_ecommerce-role"

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
