output "cloudfront_url" {
  value = aws_cloudfront_distribution.redirect_dist.domain_name
}