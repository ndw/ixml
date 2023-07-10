<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template match="h:head">
  <head>
    <meta charset='utf-8'/>
    <script src='https://www.w3.org/Tools/respec/respec-w3c' async="async" class='remove'></script>
    <script class='remove'>
      var respecConfig = {
        group: "ixml", 
        specStatus: "CG-FINAL",
        editors: [{
          name: "Steven Pemberton"
        }],
        github: {
          branch: "gh-pages",
          repoURL: "invisiblexml/ixml", 
        },
        edDraftURI: "https://invisiblexml.org/current/",
        testSuiteURI: "https://github.com/invisibleXML/ixml/tree/master/tests",
        xref: "web-platform"
      };
    </script>
  </head>
</xsl:template>

<xsl:template match="h:body">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>

    <xsl:apply-templates select="h:h1"/>

    <section id='abstract'>
      <p>Invisible XML is a language for describing the implicit
      structure of data, and a set of technologies for making that
      structure explicit as XML markup. It allows you to write a
      declarative description of the format of some text and then
      leverage that format to represent the text as structured
      information.
      </p>
    </section>

    <xsl:variable name="status" select="h:h2[@id='status']/following-sibling::h:p[1]"/>
    <xsl:variable name="rest" select="h:h2[@id='introduction'],
                                      h:h2[@id='introduction']/following-sibling::node()"/>

    <section id="sotd">
      <!-- filled in by respec -->
      <p>Please consult the <a href="https://invisiblexml.org/1.0/errata.html">errata page</a> for
      additional changes to the specification after publication.</p>
    </section>

    <xsl:apply-templates select="$rest"/>

    <section id='conformance'>
      <!-- This section is filled automatically by ReSpec. -->
    </section>
  </xsl:copy>
</xsl:template>

<xsl:template match="h:body/h:h1">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="id" select="'title'"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@href[. = 'ixml.xml']">
  <xsl:attribute name="href" select="'https://invisiblexml.org/1.0/ixml.xml'"/>
</xsl:template>

<xsl:template match="h:div[@class='toc']"/>
<xsl:template match="@shape"/>
<xsl:template match="@xml:space[not(parent::h:pre)]"/>

</xsl:stylesheet>

<!--
  <body>
    <h1 id="title">My Awesome API</h1>
    <section id='sotd'>
      <p>
        This is required.
      </p>
    </section>
    <section data-dfn-for="Foo">
      <h2>Start your spec!</h2>
      <pre class="idl">
      [Exposed=Window]
      interface Foo {
        attribute DOMString bar;
        undefined doTheFoo();
      };
      </pre>
      <section>
        <h2><dfn>bar</dfn> attribute</h2>
        <p>When getting, the {{Foo/bar}} attribute returns you a 🍹.</p>
      </section>
      <section>
        <h2><dfn>doTheFoo()</dfn> method</h2>
        <p>When called, {{Foo/doTheFoo()}} MUST behave as follows:</p>
        <ol class="algorithm">
          <li>If <var>thing</var>....</li>
          <li>Let <var>someProp</var>... of the [[DOM]] spec.</li>
        </ol>
      </section>
    </section>
-->
