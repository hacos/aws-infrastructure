resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "docs.${local.root_domain}"
  type    = "A"

  alias {
    name                   = kubernetes_ingress.main.load_balancer_ingress[0].hostname
    zone_id                = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = false
  }
}
