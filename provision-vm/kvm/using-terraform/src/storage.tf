resource "libvirt_pool" "vmdisks" {
 name = "vmdisks"
 type = "dir"
 target {
   path = "/vmdisks"
 }
  }

resource "libvirt_volume" "arch_iso" {
  name   = "archlinux-2024.08.01-x86_64.iso"
  pool   = libvirt_pool.vmdisks.name
  source = "/var/lib/libvirt/images/archlinux-2024.08.01-x86_64.iso"
}

resource "libvirt_volume" "node0_disk" {
  name   = "${var.domain_name}.qcow2"
  pool   = libvirt_pool.vmdisks.name
  size   = var.disk_size * 1024 * 1024 * 1024
  format = "qcow2"
}
