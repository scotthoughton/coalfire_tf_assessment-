
resource "aws_launch_configuration" "asg-launch-config-cf-assessment" {
  image_id        = "ami-07ebfd5b3428b6f4d"
  instance_type   = "t2.nano"
  security_groups = [aws_security_group.cf-app.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "cf-app" {
  name = "terraform-cf-app-sg"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb-sg" {
  name = "terraform-cf-assessment-elb-sg"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "asg-cf-assessment" {
  launch_configuration = aws_launch_configuration.asg-launch-config-cf-assessment.id
  availability_zones   = local.availability_zones
  min_size             = 3
  max_size             = 6

  load_balancers    = [aws_elb.cf-assessment.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-cf-assessment"
    propagate_at_launch = true
  }
}

resource "aws_elb" "cf-assessment" {
  name               = "terraform-asg-cf-assessment"
  security_groups    = [aws_security_group.elb-sg.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # Adding a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }
}
