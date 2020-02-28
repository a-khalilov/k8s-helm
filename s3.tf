provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}


resource "aws_s3_bucket" "k8s" {
  bucket = "a.khalilau-k8s"
  acl    = "private"
    versioning {
    enabled = true
  }
  tags = {
    Name = "Backet for k8s"
  }
}


resource "aws_s3_bucket_object" "volume" {
  bucket = aws_s3_bucket.k8s.id
  acl    = "private"
  key    = "volume/"
  source = "/dev/null"
}

resource "aws_s3_account_public_access_block" "block" {
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true

}
