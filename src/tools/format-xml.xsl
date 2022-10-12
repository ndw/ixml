<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                expand-text="yes"
                version="3.0">

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>
<xsl:strip-space elements="*"/>

<xsl:variable name="spaces" select="'                                        '"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template match="/">
  <html>
    <head>
      <title>ixml.xml</title>
      <link rel="stylesheet" href="css/style.css"/>
      <link rel="stylesheet" href="css/treeview.css"/>
    </head>
    <body>
      <h1>ixml.xml</h1>
      <p>This is the complete <a href="index.html">Invisible XML</a> grammar in XML.
      It is also available <a href="ixml.ixml.html">in iXML</a>.</p>
      <div class="listing">
        <div id="toggle-buttons">
          <a class="button" href="ixml.xml" download="ixml.xml">Download</a>
        </div>
        <pre id="ixml">
          <xsl:apply-templates/>
        </pre>
      </div>
      <script src="js/treeview.js"></script>
    </body>
  </html>
</xsl:template>

<xsl:template match="*">
  <xsl:sequence select="substring($spaces, 1, count(ancestor::*)*3)"/>
  <xsl:choose>
    <xsl:when test="text()">
      <span class="space"></span>
      <span class="text">
        <span class="stag">&lt;</span>
        <span class="gi">{local-name(.)}</span>
        <xsl:apply-templates select="@*"/>
        <span class="stag">&gt;</span>
        <xsl:apply-templates/>
        <span class="etag">&lt;/</span>
        <span class="gi">{local-name(.)}</span>
        <span class="etag">&gt;</span>
      </span>
      <xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="node()">
      <span class="node">
        <span class="toggle">
          <span class="open"></span>
          <span class="close"></span>
          <span>
            <span class="stag">&lt;</span>
            <span class="gi">{local-name(.)}</span>
            <xsl:apply-templates select="@*"/>
            <span class="stag">&gt;</span>
          </span>
        </span>
        <xsl:text>&#10;</xsl:text>
        <span class="dots" x-indent="{count(ancestor::*)*3}"></span>
        <span class="children">
          <xsl:apply-templates/>
        </span>
        <xsl:sequence select="substring($spaces, 1, count(ancestor::*)*3)"/>
        <span>
          <span class="space"></span>
          <span class="etag">&lt;/</span>
          <span class="gi">{local-name(.)}</span>
          <span class="etag">&gt;</span>
        </span>
      </span>
      <xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <span class="space"></span>
      <span class="empty">
        <span class="stag">&lt;</span>
        <span class="gi">{local-name(.)}</span>
        <xsl:apply-templates select="@*"/>
        <span class="stag">/&gt;</span>
      </span>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*">
  <xsl:text> </xsl:text>
  <span class="attr">
    <span class="aname">{local-name(.)}</span>
    <span class="eq">=</span>
    <span class="q">"</span>
    <span class="avalue">{.}</span>
    <span class="q">"</span>
  </span>
</xsl:template>

</xsl:stylesheet>
