variable "project_id" {
  description = "The project ID"
  type        = string
  default = "website-portifolio"
}

variable "disable_ssh_port" {
  description = "Disable SSH port"
  type        = bool
  default     = false
}

variable "availability_domain" {
  description = "The availability domain to use for the resources"
  type        = string
  default     = "lIpY:US-ASHBURN-AD-3"
}