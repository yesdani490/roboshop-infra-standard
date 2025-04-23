# module "mongodb_sg" {
#  source = "../../terraform-aws-securitygroupmodule"
#  sg_name = "mongodb"
#  sg_description = "allowing traffic"
#  project_name = var.project_name
#  vpc_id = data.aws_ssm_parameter.vpc_id.value
#   common_tags = var.common_tags
#  sg_tags = var.sg_tags
 
# }
# resource "aws_security_group_rule" "mongodb_vpn" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = data.aws_ssm_parameter.vpn_sg_id.value
#   security_group_id = module.mongodb_sg.security_group_id
# }

module "mongodb_instance" {
    source  = "terraform-aws-modules/ec2-instance/aws"
    ami = data.aws_ami.devops-ami.id
    instance_type= "t3.medium"
    vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
    subnet_id = element(split(",",data.aws_ssm_parameter.database_subnet_ids.value), 0)
    user_data = file("mongodb.sh")

    tags = merge(
    {
        Name = "mongodb"
    },var.common_tags
    )
 }