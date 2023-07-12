# Create a new branch from main
git checkout -b feature/${APPLICATION_NAME}

# Create the Terraform file
cat > terraform/services/${APPLICATION_NAME}.tf <<EOF
resource "aws_lambda_function" "${APPLICATION_NAME}" {
  function_name = "\${var.project}-${APPLICATION_NAME}"
  role          = aws_iam_role.application_name.arn
  handler       = "index.handler"
  runtime       = "${LAMBDA_RUNTIME}"
  timeout       = ${LAMBDA_TIMEOUT}

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "${APPLICATION_NAME}" {
  name = "${APPLICATION_NAME}-role"

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
EOF

# Configure git
git config user.name "GitHub Actions"
git config user.email "actions@github.com"

# Add the file to the repository
git add terraform/services/${APPLICATION_NAME}.tf
git commit -m "Chore: Add Terraform file for ${APPLICATION_NAME}"

# Push the changes to a new branch
git branch feature/${APPLICATION_NAME}
git push --set-upstream origin feature/${APPLICATION_NAME}

# Create the pull request
curl -X POST \
  -H "Authorization: Bearer ${{ secrets.SECRET }}" \
  -H "Content-Type: application/json" \
  -d "{
    \"title\": \"Create Lambda Function for ${APPLICATION_NAME}\",
    \"body\": \"This pull request creates the Lambda function for ${APPLICATION_NAME}.\",
    \"head\": \"feature/${APPLICATION_NAME}\",
    \"base\": \"main\",
    \"maintainer_can_modify\": true,
    \"draft\": false
  }" \
  "https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls"
