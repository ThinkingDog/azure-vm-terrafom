variable "subscription_id" {

}

variable "client_id" {

}

variable "client_secret" {

}

variable "tenant_id" {

}

variable "public_key" {

}

variable "public_ip_allowlist" {
  description = "List of public IP addresses to allow into the network."
  type        = list(any)
  default     = []
}
