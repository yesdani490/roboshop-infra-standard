variable "project_name" {
  default = "roboshop"
}
variable "common_tags" {
    default = {
        Project = "Roboshop"
        Environment = "Dev"
        Terraform = "true"
        Component = "App-ALB"
    }
  }
  variable "env" {
    default = "dev"
    
  }
