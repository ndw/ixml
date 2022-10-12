<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xs"
                version="3.0">

<xsl:output method="xhtml" encoding="utf-8" indent="no"
            doctype-public="-//W3C//DTD XHTML+RDFa 1.0//EN"
            doctype-system="http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"
            />
<xsl:preserve-space elements="*"/>

<xsl:param name="hash" select="''" as="xs:string"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template match="processing-instruction('pubdate')">
  <time datetime="{format-date(current-date(), '[Y0001]-[M01]-[D01]')}">
    <xsl:if test="$hash != ''">
      <xsl:attribute name="title" select="'Hash: ' || $hash"/>
    </xsl:if>
    <xsl:sequence select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
  </time>
</xsl:template>

<xsl:template match="@xml:space"/>

</xsl:stylesheet>
