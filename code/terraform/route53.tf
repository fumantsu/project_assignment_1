resource "aws_route53_zone" "lab" {
  comment           = "Temporary hosted zone"
  name              = "anaoum-lab.com"
}

resource "aws_route53_record" "lab_dns_validation" {

  name                             = "_c2a4f41a9d909365e129ce7e41c9917f.anaoum-lab.com"
  records                          = ["_4ae4d41a483715c99a3045d61247d42e.xlfgrmvvlj.acm-validations.aws."]
  ttl                              = 300
  type                             = "CNAME"
  zone_id                          = aws_route53_zone.lab.id
}