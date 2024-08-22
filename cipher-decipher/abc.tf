# main.tf



# Create an IAM group
resource "aws_iam_group" "example_group" {
  name = "example-group"
}

# Attach a policy to the group
resource "aws_iam_group_policy" "example_group_policy" {
  group = aws_iam_group.example_group.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ec2:Describe*",
          "s3:List*"
        ],
        "Effect"   : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

# Create an IAM user
resource "aws_iam_user" "example_user" {
  name = "example-user"
  path = "/"
}

# Add the user to the group
resource "aws_iam_user_group_membership" "example_user_group_membership" {
  user = aws_iam_user.example_user.name
  groups = [
    aws_iam_group.example_group.name
  ]
}

# Create an IAM role
resource "aws_iam_role" "example_role" {
  name = "example-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach a policy to the role
resource "aws_iam_role_policy" "example_role_policy" {
  role = aws_iam_role.example_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "s3:ListBucket",
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

# Attach the role to the IAM user
resource "aws_iam_user_policy_attachment" "example_user_role_attachment" {
  user       = aws_iam_user.example_user.name
  policy_arn = aws_iam_role.example_role.arn
}

# Output IAM user and role ARNs
output "user_arn" {
  value = aws_iam_user.example_user.arn
}

output "role_arn" {
  value = aws_iam_role.example_role.arn
}
