# Create iam role
resource "aws_iam_role" "dev_ec2_role" {
  name = "dev_ec2_role"
  description = "Example IAM policy granting EC2, S3, and RDS full access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com"]
        }
      },
    ]
  })
}

# Attach Role to Policy 
resource "aws_iam_role_policy" "ec2_policy" {
    name = "ec2_policy"
    role = aws_iam_role.dev_ec2_role.id

    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
          "ec2:*",
          "rds:*"
        ]
        Effect   = "Allow"
        Resource = ["*"]
      },
    ]
  })
}


# Instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "dev_ec2_role_profile"
  role = aws_iam_role.dev_ec2_role.name
}
