provider "aws" {
  region = var.region
}

variable "bucket" {
  type        = string
  description = "S3 bucket where the site code is stored"
}

variable "region" {
  type        = string
  description = "The AWS region where the site is being deployed to"
}

terraform {
  backend "s3" { }
}

data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.bucket}/*"
    ]
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket
  acl = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}