provider "aws" {
  region = "us-east-1"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "redirect_bucket" {
  bucket = "go-redirects-${random_id.suffix.hex}"
  acl    = "public-read"

  website {
    index_document = "index.html"
  }

  tags = {
    Name = "Redirect Bucket"
  }
}

resource "aws_cloudfront_distribution" "redirect_dist" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.redirect_bucket.website_endpoint
    origin_id   = "S3RedirectOrigin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3RedirectOrigin"

    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = aws_lambda_function.redirect_edge.qualified_arn
      include_body = false
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  aliases = [var.custom_domain]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "RedirectDistribution"
  }
}

resource "aws_iam_role" "lambda_edge_role" {
  name = "lambda_edge_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_edge_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/redirect.js"
  output_path = "${path.module}/redirect.zip"
}

resource "aws_lambda_function" "redirect_edge" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "redirect-edge-fn"
  role             = aws_iam_role.lambda_edge_role.arn
  handler          = "redirect.handler"
  runtime          = "nodejs18.x"
  publish          = true
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}