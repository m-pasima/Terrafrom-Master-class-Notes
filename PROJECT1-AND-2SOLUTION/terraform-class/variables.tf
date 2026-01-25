variable "ami_id" {
  type        = string
  description = "The id of the machine image on AWS"
  default     = "ami-0ab54db41b3bd815e"
}

variable "instance_type" {
  type        = string
  description = "The type of EC2 instance"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "The name of the key pair"
  default     = "demo-class"

}

variable "availability_zone" {
  type        = string
  description = "The subnet AZ"
  default     = "eu-west-2a"

}