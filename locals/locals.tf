locals {
  # 1. STRING INTERPOLATION: Joining "roboshop" + "-" + "dev" = "roboshop-dev"
  # We do this here because we cannot do it inside the 'default' value of a variable.
  instance_name = "${var.name}-${var.environment}"

  # 2. NICKNAME: Creating a short name for the long data source ID
  ami_id = data.aws_ami.RamuChelloju.id

  # 3. SETTING A CONSTANT: Hardcoding the type here means it's internal to our logic
  instance_type = "t3.micro"

  # 4. TAG MERGING: Combining common project tags with specific resource tags
  common_tags = {
    Project   = "roboshop"
    Terraform = "true"
    Environment = var.environment
  }

  # This is the final label that will be put on the EC2 instance
  ec2_final_tags = merge(
    local.common_tags,
    var.ec2_tags,
    { Name = local.instance_name } # Also adds the generated name
  )
}