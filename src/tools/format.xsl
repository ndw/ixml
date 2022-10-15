<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:f="https://nwalsh.com/ns/functions"
                exclude-result-prefixes="#all"
                expand-text="yes"
                version="3.0">

<xsl:import href="highlight-ixml.xsl"/>
<xsl:import href="highlight-xml.xsl"/>

<xsl:output method="xhtml" encoding="utf-8" indent="no"
            doctype-public="-//W3C//DTD XHTML+RDFa 1.0//EN"
            doctype-system="http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"
            />
<xsl:preserve-space elements="*"/>

<xsl:param name="ci-sha1" select="''" as="xs:string"/>
<xsl:param name="ci-build-num" select="''" as="xs:string"/>
<xsl:param name="ci-project-username" select="''" as="xs:string"/>
<xsl:param name="ci-project-reponame" select="''" as="xs:string"/>
<xsl:param name="ci-branch" select="''" as="xs:string"/>
<xsl:param name="ci-tag" select="''" as="xs:string"/>
<xsl:param name="ci-pull" select="''" as="xs:string"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template match="text()[preceding-sibling::node()[1]/self::comment()
                            and preceding-sibling::node()[1]/string() = '$date=']">
  <xsl:sequence select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
</xsl:template>

<xsl:template match="html:h2[@id='status']">
  <xsl:if test="$ci-sha1 != ''">
    <p>A version with automatically generated change
    markup <a href="autodiff.html">is available</a>. Change markup shows
    the differences between <a href="index.html">this version</a> of the
    specification and the
    <a href="https://invisiblexml.org/current/">current version</a> (at the
    time of publication).</p>
  </xsl:if>
  <xsl:next-match/>
</xsl:template>

<xsl:template match="html:body">
  <body>
    <xsl:apply-templates select="@*,node()"/>
    <footer class="docid">
      <p>
        <xsl:choose>
          <xsl:when test="$ci-pull != ''">
            <span class="dt">
              <xsl:text>Document build #{$ci-build-num} with PR #{$ci-pull} </xsl:text>
              <xsl:text>for {$ci-project-username}/{$ci-project-reponame} at </xsl:text>
              <time datetime="{format-dateTime(current-dateTime(),
                               '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][z,6-6]')}"
                    title="{format-dateTime(current-dateTime(),
                            '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][z,6-6]')}">
                <xsl:text>{format-dateTime(current-dateTime(),
                           '[H01]:[m01] on [D01] [MNn] [Y0001]')}</xsl:text>
              </time>
            </span>
            <xsl:text> </xsl:text>
            <span class="bh">
              <xsl:if test="$ci-tag != '' or $ci-branch ne 'master'">
                <xsl:sequence select="$ci-tag||$ci-branch||'/'"/>
              </xsl:if>
              <span title="{$ci-sha1}">{substring($ci-sha1, 1, 8)}</span>
            </span>
          </xsl:when>
          <xsl:when test="$ci-sha1 = ''">
            <span class="dt">
              <xsl:text>Published at </xsl:text>
              <time datetime="{format-dateTime(current-dateTime(),
                               '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][z,6-6]')}"
                    title="{format-dateTime(current-dateTime(),
                            '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][z,6-6]')}">
                <xsl:text>{format-dateTime(current-dateTime(),
                           '[H01]:[m01] on [D01] [MNn] [Y0001]')}</xsl:text>
              </time>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <span class="dt">
              <xsl:text>Document build #{$ci-build-num} </xsl:text>
              <xsl:text>for {$ci-project-username}/{$ci-project-reponame} at </xsl:text>
              <time datetime="{format-dateTime(current-dateTime(),
                               '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][z,6-6]')}"
                    title="{format-dateTime(current-dateTime(),
                            '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01][z,6-6]')}">
                <xsl:text>{format-dateTime(current-dateTime(),
                           '[H01]:[m01] on [D01] [MNn] [Y0001]')}</xsl:text>
              </time>
            </span>
            <xsl:text> </xsl:text>
            <span class="bh">
              <xsl:if test="$ci-tag != '' or $ci-branch ne 'master'">
                <xsl:sequence select="$ci-tag||$ci-branch||'/'"/>
              </xsl:if>
              <span title="{$ci-sha1}">{substring($ci-sha1, 1, 8)}</span>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </p>
    </footer>
  </body>
</xsl:template>

<xsl:template match="html:div[@class='toc']">
  <div>
    <xsl:apply-templates select="@*"/>
    <ul>
      <xsl:for-each-group select="/html:html/html:body/*" group-starting-with="html:h2">
        <xsl:if test="position() gt 2"> <!-- skip premable and status section -->
          <xsl:variable name="h2" select="current-group()[1]"/>
          <xsl:if test="empty($h2/@id)">
            <xsl:message select="'Warning: No ID on h2 for ' || string($h2)"/>
          </xsl:if>
          <li>
            <a href="#{if ($h2/@id) then $h2/@id/string() else generate-id($h2)}">
              <xsl:sequence select="$h2/node()"/>
            </a>
            <xsl:if test="current-group()[self::html:h3]">
              <ul>
                <xsl:for-each-group select="current-group()" group-starting-with="html:h3">
                  <xsl:if test="position() gt 1"> <!-- skip premable -->
                    <xsl:variable name="h3" select="current-group()[1]"/>
                    <xsl:if test="empty($h3/@id)">
                      <xsl:message select="'Warning: No ID on h3 for ' || string($h3)"/>
                    </xsl:if>
                    <li>
                      <a href="#{if ($h3/@id) then $h3/@id/string() else generate-id($h3)}">
                        <xsl:sequence select="$h3/node()"/>
                      </a>
                    </li>
                  </xsl:if>
                </xsl:for-each-group>
              </ul>
            </xsl:if>
          </li>
        </xsl:if>
      </xsl:for-each-group>
    </ul>
  </div>
</xsl:template>

<xsl:template match="html:pre[contains-token(@class, 'ixml')]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:sequence select="f:highlight-ixml(string(.))"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="html:pre[contains-token(@class, 'xml')]">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:sequence select="f:highlight-xml(string(.))"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@xml:space"/>

</xsl:stylesheet>
