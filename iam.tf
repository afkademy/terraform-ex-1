#Create an IAM User
resource "aws_iam_user" "iam_user" {
  name = "${var.vpc_name}-backend"
}

#Access Key
resource "aws_iam_access_key" "iam_access_key" {
  user = aws_iam_user.iam_user.name
}

#S3 IAM Policy
data "aws_iam_policy_document" "s3_fullaccess_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

#Attach S3 IAM Policy to User
resource "aws_iam_user_policy" "s3_fullaccess_policy" {
  name   = "s3-fullaccess-policy"
  user   = aws_iam_user.iam_user.name
  policy = data.aws_iam_policy_document.s3_fullaccess_policy.json
}