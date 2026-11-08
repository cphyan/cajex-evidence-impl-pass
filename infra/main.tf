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

# RFC 20 track D: traffic, audit, retention — declared as they should be.

resource "aws_lb_listener" "https" {
  load_balancer_arn = "arn:aws:elasticloadbalancing:eu-west-1:000000000000:loadbalancer/app/web/0"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:eu-west-1:000000000000:certificate/0"

  default_action {
    type             = "forward"
    target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:000000000000:targetgroup/web/0"
  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = "arn:aws:elasticloadbalancing:eu-west-1:000000000000:loadbalancer/app/web/0"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_cloudtrail" "org" {
  name                          = "org-trail"
  s3_bucket_name                = "orders-audit-logs"
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  include_global_service_events = true
}

resource "aws_s3_bucket" "evidence" {
  bucket              = "orders-evidence"
  object_lock_enabled = true
}

resource "aws_s3_bucket_object_lock_configuration" "evidence" {
  bucket = aws_s3_bucket.evidence.id

  rule {
    default_retention {
      mode  = "COMPLIANCE"
      years = 7
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "uploads" {
  bucket = "orders-uploads"

  rule {
    id     = "expire-uploads"
    status = "Enabled"

    expiration {
      days = 90
    }
  }
}
