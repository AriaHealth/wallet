variable "name" {
  type        = string
  description = "The name of our test stack"
  default     = "test-rolling"
}

variable "instance_type_override" {
  type        = list(string)
  description = "List of EC2 instance types to overwrite on launch_configuration"
  default     = []
}

variable "instance_type" {
  type        = string
  description = "Default EC2 instance type to be used in the launch_configuration"
  default     = "t2.micro"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be applied to the resources"
  default     = {}
}

variable "hosted_zone_id" {
  type        = string
  description = "Hosted zone id to be used for the DNS record"
  default     = ""
}
