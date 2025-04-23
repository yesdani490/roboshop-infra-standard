variable "project_name" {
  default = "roboshop"
}
variable "common_tags" {
    default = {
        Project = "Roboshop"
        Environment = "Dev"
        Terraform = "true"
        Component = "vpn"
    }
  }
  variable "env" {
    default = "dev"
    
  }

   variable "sg_tags" {
    default = {
        Project = "Roboshop"
        Environment = "Dev"
        Terraform = "true"
    } 
   }
