variable "libvirt_uri" {
  description = "LibVirt connection URI"
  type        = string
  default     = "qemu:///system"
}

variable "domain_name" {
  description = "Name of the VM domain"
  type        = string
  default     = "node0"
}

variable "memory_size" {
  description = "Memory size in MB"
  type        = number
  default     = 1024
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 30
}

variable "network_cidr" {
  description = "Network CIDR for the libvirt network"
  type        = list(string)
  default     = ["192.168.123.0/24", "2001:db8:ca2:2::1/64"]
}
