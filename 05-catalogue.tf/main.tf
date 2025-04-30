#Target Group
resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project_name}-${var.common_tags.Component}"                
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  health_check {
    enabled = true
    healthy_threshold = 2
    interval = 15
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 3

  }
}

# Launch Template

resource "aws_launch_template" "catalogue" {
  name = "${var.project_name}-${var.common_tags.Component}"

  image_id = data.aws_ami.devops-ami.id

  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Catalogue"
    }
  }

  user_data = filebase64("${path.module}/catalogue.sh")
}

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${var.project_name}-${var.common_tags.Component}"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  launch_template {
    id = aws_launch_template.catalogue.id
    version = "$Latest"
  }
  vpc_zone_identifier       = split(",",data.aws_ssm_parameter.private_subnet_ids.value)

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "Catalogue"
    propagate_at_launch = false
  }
}

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "cpu"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

resource "aws_lb_listener_rule" "health_check" {
  listener_arn = data.aws_ssm_parameter.aws_lb_listener_arn.value
  priority = 10
   action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.app.joindevops.top"]
    }
  }
}
