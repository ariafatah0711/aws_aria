resource "aws_launch_template" "web_template" {
  name_prefix   = "web-template-"
  image_id      = "ami-04f167a56786e4b09"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = file("${path.module}/user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = "LKS-Web"
    }
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    "LKS-CC-2024" = "TARGET-GROUP"
  }
}

resource "aws_lb" "web_alb" {
  name               = "web-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_groups    = [aws_security_group.web_sg.id]

  tags = {
    "LKS-CC-2024" = "ALB"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                      = "web-asg"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  vpc_zone_identifier       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  health_check_type         = "EC2"
  health_check_grace_period = 60
  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "LKS-CC-2024"
    value               = "AUTO-SCALING"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
}
