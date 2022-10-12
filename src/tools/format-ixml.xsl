<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                expand-text="yes"
                version="3.0">

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>
<xsl:preserve-space elements="*"/>

<xsl:variable name="spaces" select="'                                        '"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template match="/">
  <html>
    <head>
      <title>ixml.ixml</title>
      <link rel="stylesheet" href="css/style.css"/>
      <link rel="stylesheet" href="css/treeview.css"/>
    </head>
    <body>
      <h1>ixml.ixml</h1>
      <p>This is the complete <a href="index.html">Invisible XML</a> grammar in iXML.
      It is also available <a href="ixml.xml.html">in XML</a>.</p>
      <div class="listing">
        <div id="toggle-buttons">
          <a class="button" href="ixml.xml" download="ixml.xml">Download</a>
        </div>
        <pre id="ixml">
          <xsl:sequence select="."/>
        </pre>
      </div>
      <script src="js/treeview.js"></script>
    </body>
  </html>
</xsl:template>

</xsl:stylesheet>
