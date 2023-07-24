resource "aws_lambda_function" "app_ecommerce" {
  function_name = "${var.project}-app_ecommerce"
  role          = aws_iam_role.app_ecommerce.arn
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  timeout       = 50

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "app_ecommerce_test" {
  name = "app_ecommerce-role"

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

data "aws_iam_policy_document" "app_ecommerce_policy_document" {
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DetachNetworkInterface",
    ]
    resources = ["*"]
  }
}
