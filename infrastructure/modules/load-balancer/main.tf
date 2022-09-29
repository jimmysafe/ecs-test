locals {
  name = "${lower(var.project_name)}-${var.environment}"
}

resource "aws_security_group" "lb_sg" {
  name = "${local.name}-lb-sg"

  description = "LB security group (terraform-managed)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "lb" {
  name               = "${local.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [var.subnet_1_id, var.subnet_2_id]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "lb_tg" {
  name        = "${local.name}-lb-tg-${substr(uuid(), 0, 3)}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_lb_listener" "lb_listener" {  
  load_balancer_arn = "${aws_lb.lb.arn}"  
  port              = "80"  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.lb_tg.arn}"
    type             = "forward"  
  }
}


