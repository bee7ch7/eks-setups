module "route53_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.9.0"

  # zone_name           = var.zone_name
  zone_id             = var.zone_id
  records_jsonencoded = var.records_jsonencoded
}
