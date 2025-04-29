variable "project_name" {
    
  default = "roboshop"
}
variable "cidr_block" {
    default = "10.0.0.0/16"
  
}
variable "env" {
  default = "dev"
  
}
variable "common_tags" {
    default = {
        Project = "Roboshop"
        Environment = "Dev"
        Terraform = "true"
        Component = "vpc"
    }
  }


  variable "public_subnet_cidr" {

  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
  
}

variable "database_subnet_cidr" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
  
}

  variable "sg_tags" {
    default = {
        Project = "Roboshop"
        Environment = "Dev"
        Terraform = "true"
    }
  }

variable "igw_tags" {
    default = {
        Project = "Roboshop"
        Environment = "Dev"
        Terraform = "true"
    }
  }

