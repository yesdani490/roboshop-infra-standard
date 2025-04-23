#  module "vpn_sg" {
#  source = "../../terraform-aws-securitygroupmodule"
#  sg_name = "roboshop-vpn"
#  sg_description = "allowing all ports from my ip"
#  project_name = var.project_name
#  vpc_id = data.aws_vpc.default.id
#  common_tags = var.common_tags
#  sg_tags = var.sg_tags
 
# }

# resource "aws_security_group_rule" "vpn" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
#   security_group_id = module.vpn_sg.security_group_id
# } 

 module "vpn_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.devops-ami.id
    instance_type= "t2.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
    tags = merge(
    {
        Name = "roboshop-vpn"
    },var.common_tags
    )
 }