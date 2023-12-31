# Check if the branch already exists
branch_exists=$(git ls-remote --heads origin feature/${APPLICATION_NAME})

if [[ -z "$branch_exists" ]]; then
  echo "Branch feature/${APPLICATION_NAME} does not exist. Creating a new branch..."
  # Create a new branch from main
  git checkout -b feature/${APPLICATION_NAME}
else
  echo "Branch feature/${APPLICATION_NAME} already exists. Switching to the existing branch..."
  # Switch to the existing branch
  git checkout feature/${APPLICATION_NAME}
fi

# Create the Terraform file
cat > terraform/services/${APPLICATION_NAME}.tf <<EOF
resource "aws_lambda_function" "${APPLICATION_NAME}" {
  function_name = "\${var.project}-${APPLICATION_NAME}"
  role          = aws_iam_role.${APPLICATION_NAME}.arn
  handler       = "index.handler"
  runtime       = "${LAMBDA_RUNTIME}"
  timeout       = ${LAMBDA_TIMEOUT}

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "${APPLICATION_NAME}_test" {
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

data "aws_iam_policy_document" "${APPLICATION_NAME}_policy_document" {
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
  -H "Authorization: Bearer ${SECRET}" \
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