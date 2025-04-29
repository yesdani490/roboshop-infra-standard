module "mongodb_sg" {
 source = "../../terraform-aws-securitygroupmodule"
 sg_name = "mongodb"
 sg_description = "allowing traffic from Catalogue, User, VPN"
 project_name = var.project_name
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 common_tags = merge(
  var.common_tags,
    {
        Component = "Mongodb"
        Name = "MongoDB"
    }
 )
}

module "catalogue_sg" {
 source = "../../terraform-aws-securitygroupmodule"
 sg_name = "catalogue"
 sg_description = "allowing traffic"
 project_name = var.project_name
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 common_tags = merge(
   var.common_tags,
    {
        Component = "Catalogue"
        Name = "Catalogue"
    }
)
}

module "vpn_sg" {
 source = "../../terraform-aws-securitygroupmodule"
 sg_name = "vpn"
 sg_description = "allowing traffic"
 project_name = var.project_name
 vpc_id = data.aws_vpc.default.id
 common_tags = merge(
  var.common_tags,
    {
        Component = "VPN"
        Name = "Roboshop vpn"
    }
 )
}
module "web_sg" {
 source = "../../terraform-aws-securitygroupmodule"
 sg_name = "web"
 sg_description = "allowing traffic"
 project_name = var.project_name
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 common_tags = merge(
  var.common_tags,
    {
        Component = "Web"
        Name = "Web"
    }
 )
}

module "app_alb_sg" {
 source = "../../terraform-aws-securitygroupmodule"
 sg_name = "app_alb"
 sg_description = "allowing traffic"
 project_name = var.project_name
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 common_tags = merge(
  var.common_tags,
    {
        Component = "App_alb"
        Name = "App_alb"
    }
    )
}
module "web_alb_sg" {
 source = "../../terraform-aws-securitygroupmodule"
 sg_name = "web_alb"
 sg_description = "allowing traffic"
 project_name = var.project_name
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 common_tags = merge(
  var.common_tags,
    {
        Component = "Web_alb",
        Name = "Web_alb"
    }
 )
}

resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  description = "Allowing all ports "
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks =  ["${chomp(data.http.icanhazip.body)}"]
  security_group_id = module.vpn_sg.security_group_id
}
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  description = "Allowing port number 27017 from Catalogue"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.security_group_id
  security_group_id = module.mongodb_sg.security_group_id
}
resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  description = "Allowing port 22 from vpn "
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.mongodb_sg.security_group_id
}

resource "aws_security_group_rule" "catalogue_vpn" {
  type              = "ingress"
  description = "Allowing port 22 from vpn "
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.catalogue_sg.security_group_id
}

resource "aws_security_group_rule" "catalogue_app_alb" {
  type              = "ingress"
  description = "Allowing port 8080 from APP ALB "
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  security_group_id = module.catalogue_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_web" {
  type              = "ingress"
  description = "Allowing port 80 from Web "
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id
}


resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  description = "Allowing port 80 from vpn "
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "web_web_alb" {
  type              = "ingress"
  description = "Allowing port 80 from Web ALB "
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb_sg.security_group_id
  security_group_id = module.web_sg.security_group_id
}

resource "aws_security_group_rule" "web_vpn" {
  type              = "ingress"
  description = "Allowing port 80 from vpn "
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  security_group_id = module.web_sg.security_group_id
}
resource "aws_security_group_rule" "web_alb_internet" {
  type              = "ingress"
  description = "Allowing port 80 from Internet "
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.security_group_id
}
