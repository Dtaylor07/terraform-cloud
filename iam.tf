
// IAM role for Lambda


data "aws_iam_policy_document" "lambda-assume-policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-policy.json
}

# resource "aws_iam_policy" "policy" {
#   name        = "terraform-cloud-policy"
#   description = "A test policy"
#   policy      = data.aws_iam_policy_document.tf-cloud-policy.json
# }

# resource "aws_iam_role" "test_role" {
#   name = "terraform_cloud_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           AWS = "arn:aws:iam::199660179115:root"
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "tf-cloud-policy-attach" {
#   role       = aws_iam_role.test_role.name
#   policy_arn = aws_iam_policy.policy.arn
# }