<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:ext="http://nwalsh.com/xslt"
                xmlns:f="https://nwalsh.com/ns/functions"
                xmlns:m="https://nwalsh.com/ns/modes"
                xmlns:rng="http://relaxng.org/ns/structure/1.0"
                xmlns:xi='http://www.w3.org/2001/XInclude'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:import href="../../build-tools/highlight-xml.xsl"/>

<xsl:output method="html" html-version="5"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:key name="id" match="*" use="@id"/>

<xsl:param name="ixml.rng" as="xs:string" required="yes"/>
<xsl:variable name="rng" select="doc($ixml.rng)/*"/>

<xsl:template match="/">
  <xsl:variable name="composed">
    <xsl:apply-templates select="h:html"/>
  </xsl:variable>

  <xsl:apply-templates select="$composed/h:html" mode="patch-links"/>
</xsl:template>

<xsl:template match="xi:include">
  <xsl:apply-templates
      select="ext:xinclude(., map { QName('', 'fixup-xml-base'): false() })/*"/>
</xsl:template>

<xsl:template match="h:div[@ixml-pattern]">
  <xsl:copy>
    <xsl:copy-of select="@* except @ixml-pattern"/>
    <xsl:attribute name="id" select="@ixml-pattern"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="h:div[contains-token(@class, 'synopsis')]">
  <xsl:copy>
    <xsl:copy-of select="@*"/>

    <xsl:variable name="patn" select="../@ixml-pattern/string()"/>
    <xsl:variable name="def" select="$rng/rng:define[@name=$patn]"/>

    <xsl:if test="empty($def)">
      <xsl:message select="'No definition for', $patn"/>
    </xsl:if>

    <pre><code>
      <xsl:sequence select="$def ! f:highlight-xml(.)"/>
    </code></pre>
  </xsl:copy>
</xsl:template>

<xsl:template match="rng:ref/@name" mode="m:highlight-xml"
              expand-text="yes">
  <xsl:text> </xsl:text>
  <span class="attr">
    <span class="aname">{local-name(.)}</span>
    <span class="eq">=</span>
    <span class="q">"</span>
    <x-link><xsl:value-of select="."/></x-link>
    <span class="q">"</span>
  </span>
</xsl:template>

<!-- ============================================================ -->

<xsl:mode name="patch-links" on-no-match="shallow-copy"/>

<xsl:template match="h:body" mode="patch-links">
  <xsl:variable name="intro" select="h:div[@id='introduction']"/>
  <xsl:copy>
    <xsl:apply-templates select="@*,$intro/preceding-sibling::node()"
                         mode="patch-links"/>
    <xsl:apply-templates select="." mode="toc"/>
    <xsl:apply-templates select="$intro, $intro/following-sibling::node()"
                         mode="patch-links"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="h:x-link" mode="patch-links">
  <xsl:variable name="id" select="string(.)"/>
  <xsl:choose>
    <xsl:when test="key('id', $id)">
      <a href="#{$id}"><xsl:value-of select="$id"/></a>
    </xsl:when>
    <xsl:when test="key('id', 'a.' || $id)">
      <a href="#a.{$id}"><xsl:value-of select="$id"/></a>
    </xsl:when>
    <xsl:when test="key('id', 'e.' || $id)">
      <a href="#e.{$id}"><xsl:value-of select="$id"/></a>
    </xsl:when>
    <xsl:when test="key('id', 'h.' || $id)">
      <a href="#h.{$id}"><xsl:value-of select="$id"/></a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message select="'No id: ' || $id"/>
      <xsl:value-of select="$id"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="h:body" mode="toc">
  <div class="toc">
    <ul>
      <xsl:apply-templates select="h:div" mode="toc"/>
    </ul>
  </div>
</xsl:template>

<xsl:template match="h:div" mode="toc">
  <li>
    <a href="#{@id}">
      <xsl:sequence select="h:header/h:h1/node()
                            |h:header/h:h2/node()
                            |h:header/h:h3/node()
                            |h:header/h:h4/node()"/>
    </a>
    <xsl:if test="h:div and count(ancestor::h:div) lt 1">
      <ul>
        <xsl:apply-templates select="h:div" mode="toc"/>
      </ul>
    </xsl:if>
  </li>
</xsl:template>

</xsl:stylesheet>
