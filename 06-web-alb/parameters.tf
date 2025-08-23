 resource "aws_ssm_parameter" "web_alb_listener_arn" {
  name  = "/${var.project_name}/${var.env}/web_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.frontend.arn
  }
