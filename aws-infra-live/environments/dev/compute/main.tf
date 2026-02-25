data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraform-state-file-s3-23022026"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "terraform-state-file-s3-23022026"
    key    = "dev/security/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "database" {
  backend = "s3"
    config = {
        bucket = "terraform-state-file-s3-23022026"
        key    = "dev/database/terraform.tfstate"
        region = "us-east-1"
}
}

data "aws_ami" "amazon_linux" {
  most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["al2023-ami-*-x86_64"]
    }
}

resource "aws_instance" "app" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.app_sg_id]

  associate_public_ip_address = true
  key_name = "daws-88s"

  user_data = <<-EOF
#!/bin/bash
# 1. Update and Install software
dnf update -y
dnf install -y httpd php php-mysqlnd mariadb105

# 2. Start Web Server
systemctl enable httpd
systemctl start httpd

# 3. GET THE DB HOST from Terraform
# We use sed to inject the actual IP into the PHP file later
DB_HOST="${data.terraform_remote_state.database.outputs.db_private_ip}"

# 4. Create the PHP file
# NOTE: We removed the quotes around PHP so bash can process the $DB_HOST variable
cat <<PHP > /var/www/html/index.php
<?php
// Using the variable injected by Terraform
\$conn = new mysqli("$DB_HOST", "root", "YourPassword123", "devdb");

if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
}

// Automatic Table Creation (If it doesn't exist)
\$conn->query("CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255))");

if (\$_SERVER["REQUEST_METHOD"] == "POST") {
    \$name = \$_POST["name"];
    \$conn->query("INSERT INTO users (name) VALUES ('\$name')");
}

\$result = \$conn->query("SELECT * FROM users");

echo "<h2>Dev Environment App</h2>";
echo "<form method='post'>
        Name: <input type='text' name='name'>
        <input type='submit' value='Submit'>
      </form>";

echo "<h3>Stored Data:</h3>";
if (\$result) {
    while (\$row = \$result->fetch_assoc()) {
        echo \$row["id"] . " - " . \$row["name"] . "<br>";
    }
}

\$conn->close();
?>
PHP

# 5. Fix permissions so Apache can read the file
chown apache:apache /var/www/html/index.php
EOF
  tags = {
    Environment = var.environment
    Layer       = "Compute"
    Name        = "${var.environment}-app-ec2"
  }
}