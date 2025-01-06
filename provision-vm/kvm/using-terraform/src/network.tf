resource "libvirt_network" "devsecops2" {
  name      = "devsecops2"
  mode      = "nat"
  domain    = "devsecops2.local"
  addresses = var.network_cidr
  autostart = true
  
  dhcp {
    enabled = true
  }
  
  dns {
    enabled    = true
    local_only = true
  }
}
