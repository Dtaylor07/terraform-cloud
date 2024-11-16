resource "aws_iam_policy" "policy" {
  name        = "terraform-cloud-policy1"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.tf-cloud-policy.json
}

data "aws_iam_policy_document" "tf-cloud-policy" {
  version = "2012-10-17"
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "test_role" {
  name = "terraform_cloud_role_1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::199660179115:root"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tf-cloud-policy-attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.policy.arn
}