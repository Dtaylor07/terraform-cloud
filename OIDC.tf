data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  github_repositories = [
    "terraform-cloud"
  ]
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

################################################################################
# GitHub OIDC Role
################################################################################

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "GithubOidcAuth"
    effect = "Allow"
    actions = [
      "sts:TagSession",
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      # Strip `repo:` to normalize for cases where users may prepend it
      values = [for repo in local.github_repositories : "repo:Dtaylor07/${repo}:${upper(var.environment)}"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "github-oidc-Role"
  description        = "GitHub OIDC Role that adhere to best practices"
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_policy" "oidc_policy" {
  name        = "github-oidc-policy-document"
  description = "github oidc admin policy document"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_admin_policy" {
  policy_arn = aws_iam_policy.oidc_policy.arn
  role       = aws_iam_role.this.name
}



// comment out


# resource "aws_iam_role" "github_oidc_role" {
#   name               = "github-oidc-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Federated = "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
#         },
#         Action = "sts:AssumeRoleWithWebIdentity",
#         Condition = {
#           StringEquals = {
#             "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
#           },
#           StringLike = {
#             "token.actions.githubusercontent.com:sub" = "repo:${local.github_repositories[0]}:*"
#           }
#         }
#       }
#     ]
#   })
# }
