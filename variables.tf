variable "publisher" {
  default = "Canonical"
}

variable "offer" {
  default = "UbuntuServer"
}

variable "sku" {
  default = "18.04-LTS"
}

variable "public_key" {

}

variable "public_ip_allowlist" {
  description = "List of public IP addresses to allow into the network."
  type        = list(any)
  default     = []
}
