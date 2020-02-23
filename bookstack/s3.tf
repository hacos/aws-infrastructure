data "aws_caller_identity" "current" {}

resource "aws_iam_user" "main" {
  name = var.prefix
}

resource "aws_iam_access_key" "main" {
  user = aws_iam_user.main.name
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.prefix}-${data.aws_caller_identity.current.account_id}-${var.region}"
  acl    = "private"

  tags = {
    environment = local.environment
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.main.arn}"
      },
      "Action": [ "s3:*" ],
      "Resource": [
        "${aws_s3_bucket.main.arn}",
        "${aws_s3_bucket.main.arn}/*"
      ]
    }
  ]
}
EOF
}
