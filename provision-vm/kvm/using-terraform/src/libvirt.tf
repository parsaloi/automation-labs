# Define the network
resource "libvirt_network" "devsecops2" {
  name      = "devsecops2"
  mode      = "nat"
  domain    = "devsecops2.local"
  addresses = ["192.168.123.0/24", "2001:db8:ca2:2::1/64"]
  autostart = true

  dhcp {
    enabled = true
  }

  dns {
    enabled    = true
    local_only = true
  }
}

# Define the storage pool for the ISO
resource "libvirt_pool" "sysimg" {
  name = "sysimg"
  type = "dir"
  target {
    path = "/var/lib/libvirt/images/more"
  }
}

# Create the ISO volume
resource "libvirt_volume" "arch_iso" {
  name = "archlinux-2024.08.01-x86_64.iso"
  pool = libvirt_pool.sysimg.name
  source = "/var/lib/libvirt/images/archlinux-2024.08.01-x86_64.iso"
}

# Create a disk volume
resource "libvirt_volume" "node0_disk" {
  name   = "node0.qcow2"
  pool   = libvirt_pool.sysimg.name
  size   = 30 * 1024 * 1024 * 1024
  format = "qcow2"
}

# Define the domain (VM)
resource "libvirt_domain" "node0" {
  name   = "node0"
  memory = "1024"

  cpu {
    mode = "host-passthrough"
  }

  boot_device {
    dev = ["cdrom", "hd"]
  }

  firmware = "/usr/share/OVMF/x64/OVMF_VARS.4m.fd"
  nvram {
    file = "/var/lib/libvirt/qemu/nvram/node0_VARS.fd"
  }

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

  machine  = "q35"

  xml {
    xslt = <<-EOXSLT
    <?xml version="1.0" ?>
    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output omit-xml-declaration="yes" indent="yes"/>
      <xsl:template match="@*|node()">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:template>
      <xsl:template match="/domain/os">
        <os>
          <xsl:apply-templates select="@*"/>
          <type arch="x86_64" machine="q35">hvm</type>
          <loader readonly="yes" type="pflash">/usr/share/OVMF/x64/OVMF_VARS.4m.fd</loader>
          <nvram>/var/lib/libvirt/qemu/nvram/node0_VARS.fd</nvram>
          <boot dev='cdrom'/>
          <boot dev='hd'/>
        </os>
      </xsl:template>
    </xsl:stylesheet>
    EOXSLT
  }

  lifecycle {
    ignore_changes = [
      disk[1],
    ]
  }
}

# Output the VM's IP address
output "node0_ip" {
  value       = libvirt_domain.node0.network_interface[0].addresses[0]
  description = "The IP address of node0"
}
