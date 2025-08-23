module "web" {
source = "../../terraform-roboshop-app"
env = var.env
project_name = var.project_name
common_tags = var.common_tags#


#TargetGroup
health_check = var.health_check  
vpc_id = data.aws_ssm_parameter.vpc_id.value
target_group_port = var.target_group_port

#LaunchTemplate

image_id = data.aws_ami.devops-ami.id
instance_type = "t2.micro"
security_group_id = data.aws_ssm_parameter.web_sg_id.value

launch_template_tags = var.launch_template_tags
user_data = filebase64("${path.module}/web.sh")

#AutoScalling

  vpc_zone_identifier       = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  tag = var.autoscaling_tags
 
  #AutoScaling polity, good with optional params

  #Listener rule
alb_listener_arn = data.aws_ssm_parameter.web_alb_listener_arn.value
rule_priority = 10
host_header = "joindevops.top"

}



