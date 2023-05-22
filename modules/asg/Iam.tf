# Create an IAM role, attach S3FullAccess policy to it.
# Attach this role to your Auto-Scaling group.
# Log in to one of your instances, download install AWS CLI, and make sure that you can run aws s3 commands from inside this instance

resource "aws_iam_role" "s3_full_access_role" {
  name = "S3FullAccessRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_full_access_attachment" {
  role       = aws_iam_role.s3_full_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.s3_full_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "fsb_instance_profile" {
  name = "FsbInstanceProfile"

  role = aws_iam_role.s3_full_access_role.name
}
