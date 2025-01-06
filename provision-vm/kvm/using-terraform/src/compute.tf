resource "libvirt_domain" "node0" {
  name   = var.domain_name
  memory = var.memory_size
  
  cpu {
    mode = "host-passthrough"
  }
  
  boot_device {
    dev = ["cdrom", "hd"]
  }
  
  firmware = "/usr/share/edk2/x64/OVMF_CODE.4m.fd"
  nvram {
    file     = "/var/lib/libvirt/qemu/nvram/${var.domain_name}_VARS.fd"
    template = "/usr/share/edk2/x64/OVMF_VARS.4m.fd"
  }
  
  machine = "q35"
  
  disk {
    volume_id = libvirt_volume.node0_disk.id
  }
  
  disk {
    volume_id = libvirt_volume.arch_iso.id
  }
  
  network_interface {
    network_id     = libvirt_network.devsecops2.id
    wait_for_lease = true
  }
  
  graphics {
    type           = "vnc"
    listen_type    = "address"
    listen_address = "0.0.0.0"
    autoport       = true
  }
  
  video {
    type = "virtio"
  }
  
  xml {
    xslt = file("${path.module}/templates/ovmf_loader.xsl")
  }
  
  lifecycle {
    ignore_changes = [
      disk[1],
    ]
  }
}
