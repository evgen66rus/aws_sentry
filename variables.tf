variable "instance_name" {
  type        = string
  default     = "Sentry"
}

variable "subnets__ids_list" {
  type        = list(string)
  default     = ["subnet-111111", "subnet-222222"]
}

variable "vpc_id" {
  type        = string
  default     = "vpc-abcd1234"
}

variable "certificate_arn" {
  type        = string
  default     = ""
}

variable "key_pair" {
  type        = string
  default     = "mykey"
}

variable "ec2_az" {
  description = "Available zone to launch the instance in"
  type        = string
  default     = "us-east-2a"
}

variable "route53_zone_id" {
  description = "an ID of your DNS zone"
  type        = string
  default     = ""
}

variable "route53_record" {
  description = "fqdn name of a record you are creating, i.e sentry.example.com"
  type        = string
  default     = "sentry.it-systems.link"
}