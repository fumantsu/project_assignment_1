resource "aws_acm_certificate" "lab" {
  domain_name       = "anaoum-lab.com"
  key_algorithm     = "RSA_2048"
  region            = "eu-west-1"
  validation_method = "DNS"
}