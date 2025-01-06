<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/domain/os">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <loader readonly="yes" type="pflash">/usr/share/ovmf/x64/OVMF_CODE.fd</loader>
      <nvram>/var/lib/libvirt/qemu/nvram/node0_VARS.fd</nvram>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
