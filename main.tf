resource "aws_lb" "sentry-alb-tf" {
  name               = "sentry-alb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets__ids_list
  security_groups    = [aws_security_group.sentry_alb.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group_attachment" "sentry-tg-tf" {
  target_group_arn = aws_lb_target_group.sentry-tg-tf.arn
  target_id        = aws_instance.Sentry.id
  port             = 9000
}

resource "aws_lb_target_group" "sentry-tg-tf" {
  name     = "sentry-tg-tf"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "sentry-alb" {
  load_balancer_arn = aws_lb.sentry-alb-tf.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sentry-tg-tf.arn
  }
}

resource "aws_instance" "Sentry" {
  ami = "ami-00399ec92321828f5"
  instance_type = "t3a.medium"
  key_name = var.key_pair
  availability_zone = var.ec2_az
  root_block_device  {
    volume_type = "gp2"
    volume_size = 40
  }
  vpc_security_group_ids = [aws_security_group.sentry_ssh.id, aws_security_group.sentry_sg.id]
  user_data = file("init-script.sh")
  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "sentry_alb" {
  name        = "sentry_alb"
  description = "Allow inbound traffic to alb on port 443"

  ingress {
    description      = "allow from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sentry_alb"
  }
}

resource "aws_security_group" "sentry_sg" {
  name        = "sentry_sg"
  description = "Allow inbound traffic to port 9000"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sentry_sg"
  }
}

resource "aws_security_group_rule" "sentry" {
  type              = "ingress"
  from_port         = 9000
  to_port           = 9000
  protocol          = "tcp"
  source_security_group_id = aws_security_group.sentry_alb.id
  security_group_id = aws_security_group.sentry_sg.id
}

resource "aws_security_group" "sentry_ssh" {
  name        = "sentry_ssh"
  description = "Allow inbound traffic to port 22"

  ingress {
    description      = "allow from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Sentry_ssh"
  }
}

resource "aws_route53_record" "sentry" {
  zone_id = var.route53_zone_id
  name    = var.route53_record
  type    = "A"

  alias {
    name                   = aws_lb.sentry-alb-tf.dns_name
    zone_id                = aws_lb.sentry-alb-tf.zone_id
    evaluate_target_health = true
  }
}
