<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
 	exclude-result-prefixes="java">

<xsl:output indent='yes'/>
<xsl:template match="/TXLife">
	<TranData>
 <Head>
	    <TranDate><xsl:value-of select="TransExeDate"/></TranDate>
	    <TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur6Time()"/></TranTime>
	    <TellerNo><xsl:value-of select="Teller"/></TellerNo>
	    <TranNo><xsl:value-of select="TransNo"/></TranNo>
	    <NodeNo><xsl:value-of select="BankCode"/><xsl:value-of select="Branch"/></NodeNo>
	    <xsl:copy-of select="Head/*"/>
	    <BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
     </Head>
    <Body>
      <ContNo><xsl:value-of select="PolNumber"/></ContNo> <!-- 保险单号 -->
      <ProposalPrtNo><xsl:value-of select="HOAppFormNumber"/></ProposalPrtNo> <!-- 投保单(印刷)号 -->
      <ContPrtNo></ContPrtNo> <!-- 保单合同印刷号 -->
    </Body>
	</TranData>
</xsl:template>
</xsl:stylesheet>
