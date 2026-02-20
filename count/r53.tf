resource "aws_route53_record" "www" {
  count   = length(var.instances)
  zone_id = var.zone_id

  # Interpolation to create full domain names (e.g., mongodb.daws88s.online)
  name    = "${var.instances[count.index]}.${var.domain_name}"
  type    = "A"
  ttl     = 1

  # Fetch the private IP of the matching instance created in ec2.tf
  records = [aws_instance.example[count.index].private_ip]
}