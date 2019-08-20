<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="utf-8"/>

  <xsl:variable name="langCodes" select="document('./langCodeMap.xml')/langCodeMap/langCode"/>
  <xsl:variable name="langIn" select="translate(/article/@xml:lang,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
  <!-- <xsl:variable name="langOut">eng</xsl:variable> -->
  <xsl:variable name="langOut" select="$langCodes[@iso639-1=$langIn]/@iso639-2"/>

  <xsl:template match="/">
  <import>
    <opusDocument>
          <xsl:attribute name="language"> 
            <xsl:value-of select="$langOut"/>
          </xsl:attribute>
          <xsl:attribute name="type">
            <xsl:text>article</xsl:text>
          </xsl:attribute>
          <xsl:if test="//article-meta/fpage">
            <xsl:attribute name="pageFirst">
              <xsl:value-of select="//article-meta/fpage"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="//article-meta/lpage">
            <xsl:attribute name="pageLast">
              <xsl:value-of select="//article-meta/lpage"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="//article-meta/volume">
            <xsl:attribute name="volume">
              <xsl:value-of select="//article-meta/volume"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="//article-meta/issue">
            <xsl:attribute name="issue">
              <xsl:value-of select="//article-meta/issue"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:attribute name="publisherName">
            <xsl:value-of select="//journal-meta/publisher/publisher-name"/>
          </xsl:attribute>
          <xsl:if test="//journal-meta/publisher/publisher-loc">
            <xsl:attribute name="publisherPlace">
              <xsl:value-of select="//journal-meta/publisher/publisher-loc"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:attribute name="belongsToBibliography">
            <xsl:text>false</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="serverState">
            <xsl:text>unpublished</xsl:text>
          </xsl:attribute>
          <!-- 
          language="eng"
          type="article|bachelorthesis|bookpart|book|conferenceobject|contributiontoperiodical|coursematerial|diplom|doctoralthesis|examen|habilitation|image|lecture|magister|masterthesis|movingimage|other|periodical|preprint|report|review|studythesis|workingpaper"
          pageFirst=""
          pageLast=""
          pageNumber=""
          edition=""
          volume=""
          issue=""
          publisherName=""
          publisherPlace=""
          creatingCorporation=""
          contributingCorporation=""
          belongsToBibliography="true|false"
          serverState="audited|published|restricted|inprogress|unpublished"
          -->
      <titlesMain>
          <titleMain>
            <xsl:attribute name="language"><xsl:value-of select="$langOut"/></xsl:attribute>
            <xsl:value-of select="//article-meta/title-group/article-title"/>
          </titleMain>
      </titlesMain>
          <xsl:if test="//journal-meta/journal-title-group/journal-title">
      <titles>
            <title> 
              <xsl:attribute name="language"><xsl:value-of select="$langOut"/> </xsl:attribute>
              <xsl:attribute name="type"><xsl:text>parent</xsl:text></xsl:attribute> 
              <xsl:value-of select="//journal-meta/journal-title-group/journal-title"/>
            </title>
      </titles>
          </xsl:if>
          <xsl:if test="//article-meta/abstract">
      <abstracts>
            <abstract>
              <xsl:attribute name="language"><xsl:value-of select="$langOut"/></xsl:attribute>
              <xsl:value-of select="//article-meta/abstract"/>
            </abstract>
      </abstracts>
          </xsl:if>
      <persons>
          <xsl:for-each select="//article-meta/contrib-group/contrib">
            <person>
                <xsl:attribute name="role">
                  <xsl:choose>
                    <xsl:when test="@contrib-type='guest-editor'">
                       <xsl:text>editor</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                       <xsl:value-of select="@contrib-type"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="firstName"><xsl:value-of select="name/given-names"/></xsl:attribute>
                <xsl:attribute name="lastName"><xsl:value-of select="name/surname"/></xsl:attribute>
                <!--
                role="advisor|author|contributor|editor|referee|translator|submitter|other"
                firstName=""
                lastName=""
                academicTitle=""
                email=""
                allowEmailContact="true|false"
                placeOfBirth=""
                dateOfBirth="1999-12-31"
                -->
                <!--
                <identifiers>
                  <identifier type="orcid|gnd|intern">?????</identifier>
                </identifiers>
                -->
            </person>
          </xsl:for-each>
      </persons>
          <xsl:if test="//article-meta/kwd-group/kwd">
      <keywords>
          <xsl:for-each select="//article-meta/kwd-group/kwd">
            <keyword> 
              <xsl:attribute name="language"><xsl:value-of select="$langOut"/></xsl:attribute>
              <xsl:attribute name="type"><xsl:text>uncontrolled</xsl:text></xsl:attribute>
              <xsl:value-of select="normalize-space(text())"/>
            </keyword>
          </xsl:for-each>
      </keywords>
          </xsl:if>
      <!--
      <dnbInstitutions>
          <dnbInstitution id="<integer>" role="grantor|publisher"/>
      </dnbInstitutions>
      -->
      <dates>
          <date>
             <xsl:attribute name="type"><xsl:text>published</xsl:text></xsl:attribute>
             <xsl:attribute name="monthDay">
                <xsl:text>--</xsl:text>
                <xsl:value-of select="format-number(//article-meta/pub-date[contains(@pub-type,'ppub')]/month,'00')"/>
                <xsl:text>-</xsl:text>
                <xsl:choose>
                  <xsl:when test="//article-meta/pub-date[contains(@pub-type,'ppub')]/day">
                     <xsl:value-of select="format-number(//article-meta/pub-date[contains(@pub-type,'ppub')]/day,'00')"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>01</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
             </xsl:attribute>
             <xsl:attribute name="year">
                <xsl:value-of select="//article-meta/pub-date[contains(@pub-type,'ppub')]/year"/>
             </xsl:attribute>
          </date>
      </dates>
      <identifiers>
          <identifier>
             <xsl:attribute name="type"><xsl:text>issn</xsl:text></xsl:attribute>
             <xsl:value-of select="//journal-meta/issn[@pub-type='ppub']"/>
          </identifier>
          <identifier>
             <xsl:attribute name="type"><xsl:text>doi</xsl:text></xsl:attribute>
             <xsl:value-of select="//article-meta/article-id[@pub-id-type='doi']"/>
          </identifier>
        <xsl:if test="//article-meta/article-id[@pub-id-type='pmid']">
          <identifier>
             <xsl:attribute name="type"><xsl:text>pmid</xsl:text></xsl:attribute>
             <xsl:value-of select="//article-meta/article-id[@pub-id-type='pmid']"/>
          </identifier>
        </xsl:if>
      </identifiers>
      <!--
      <notes>
          <note visibility="private|public">?????</note>
      </notes>
      <collections>
          <collection id="<integer>"/>
      </collections>
      <series>
          <seriesItem id="<integer>" number=""/>
      </series>
      <enrichments>
          <enrichment key="">?????</enrichment>
      </enrichments>
      <licences>
          <licence id="<integer>"/>
      </licences>
      <files basedir="">
          <file 
                path=""
                name=""
                language=""
                displayName=""
                visibleInOai="true|false"
                visibleInFrontdoor="true|false"
                sortOrder="<int>">
            <comment>?????</comment>
            <checksum type="md5|sha256|sha512">?????</checksum>
          </file>
      </files>
      -->
    </opusDocument>
  </import>
  </xsl:template>

</xsl:stylesheet>
