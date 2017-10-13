<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TranData>
			<xsl:apply-templates select="TXLife/TXLifeRequest" />

			<Body>
				<xsl:apply-templates select="TXLife/TXLifeRequest/OLife/Holding/Policy" />
			</Body>
		</TranData>
	</xsl:template>

	<!-- 报文头结点 -->
	<xsl:template name="Head" match="TXLifeRequest">
		<Head>
			<TranDate>
				<xsl:value-of select="TransExeDate" />
			</TranDate>
			<TranTime>
				<xsl:value-of select="TransExeTime" />
			</TranTime>
			<TellerNo>
				<xsl:value-of select="TellerCode" />
			</TellerNo>
			<TranNo>
				<xsl:value-of select="TransRefGUID" />
			</TranNo>
			<NodeNo>
				<xsl:value-of select="RegionCode" />
				<xsl:value-of select="BranchCode" />
			</NodeNo>
			<BankCode>
				<xsl:value-of select="../Head/TranCom/@outcode" />
			</BankCode>
			<xsl:copy-of select="../Head/*" />
			<SourceType>
				<xsl:apply-templates select="OLifeExtension/TransChannel" />
			</SourceType>
		</Head>
	</xsl:template>

	<xsl:template name="Body" match="Policy">
		<!-- 保单号 -->
		<ContNo>
			<xsl:value-of select="PolNumber" />
		</ContNo>
		<!-- 投保单号 -->
		<ProposalPrtNo></ProposalPrtNo>
		<!-- 保单印刷号 -->
		<ContPrtNo></ContPrtNo>
	</xsl:template>

	<!-- 银行保单销售渠道: 0=柜面，1=网银，8=自助终端 -->
	<xsl:template match="TransChannel">
		<xsl:choose>
			<xsl:when test=".='DSK'">0</xsl:when><!--	银保通柜面 -->
			<xsl:when test=".='INT'">1</xsl:when><!--	网银 -->
			<xsl:when test=".='IEX'">1</xsl:when><!--	网银 -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
