# Fixture for cajeX's IaC templates (RFC 20 track E). Never applied.
# Storage is declared encrypted at rest; only HTTPS is open to the internet.

resource "aws_kms_key" "data" {
  description         = "Keys for the orders data"
  enable_key_rotation = true
}

resource "aws_db_instance" "orders" {
  identifier        = "orders"
  engine            = "postgres"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20
  storage_encrypted = true
  kms_key_id        = aws_kms_key.data.arn
}

resource "aws_ebs_volume" "scratch" {
  availability_zone = "eu-west-1a"
  size              = 10
  encrypted         = true
}

resource "aws_security_group" "web" {
  name = "web"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
