<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
 <TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
		<xsl:apply-templates select="Transaction/Transaction_Body" />
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="Transaction_Header">
<Head>
	<TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	<TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
	<TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	<NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<xsl:template name="Body" match="Transaction_Body">
	<ContNo><xsl:value-of select="PbInsuSlipNo"/></ContNo>
	<ProposalPrtNo></ProposalPrtNo>
	<ContPrtNo><xsl:value-of select="BkVchNo"/></ContPrtNo>
	<!-- FIXME 待确认 我方的请求报文里没有该字段 OldLogNo:原交易保险公司流水号 -->
	<OldLogNo><xsl:value-of select="BkOthOldSeq"/></OldLogNo>
</xsl:template>
</xsl:stylesheet>

