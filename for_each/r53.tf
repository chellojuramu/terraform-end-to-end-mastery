resource "aws_route53_record" "www" {
  # This tells Terraform: "Look at the EC2 instances we just made"
  # It creates 10 DNS records because there are 10 EC2 instances
  for_each = aws_instance.example

  zone_id = var.zone_id

  # Interpolation: each.key is the server name (e.g., mongodb)
  # Result: mongodb.daws88s.online
  name    = "${each.key}.${var.domain_name}"

  type    = "A"
  ttl     = 1

  # each.value refers to the actual EC2 resource data
  # We reach inside that data to grab the 'private_ip'
  records = [each.value.private_ip]

  allow_overwrite = true
}

# SPECIAL RECORD: For the Frontend (Public Access)
resource "aws_route53_record" "frontend" {
  zone_id = var.zone_id
  name    = "roboshop.${var.domain_name}"
  type    = "A"
  ttl     = 1

  # LOOKUP: This searches the 'example' instances for one named "frontend"
  # It grabs the PUBLIC IP so customers can actually reach the website
  records = [lookup(aws_instance.example, "frontend").public_ip]

  allow_overwrite = true
}