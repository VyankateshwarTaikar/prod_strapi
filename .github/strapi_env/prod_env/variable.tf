variable "ssh_public_key" {
  type = string
  default = null
} 

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default = null
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default = null
}
