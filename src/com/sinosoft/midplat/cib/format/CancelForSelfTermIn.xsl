<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">
	<xsl:template match="/INSU">
		<TranData>
			<!-- 报文头 -->
			<Head>
				<TranDate><xsl:value-of select="MAIN/BANK_DATE"/></TranDate>
				<xsl:variable name ="time" select ="java:com.sinosoft.midplat.common.DateUtil.getCur8Time()"/>
				<TranTime><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.time8to6($time)"/></TranTime>
				<TellerNo><xsl:value-of select="MAIN/TELLERNO"/></TellerNo>
				<TranNo><xsl:value-of select="MAIN/TRANSRNO"/></TranNo>
				<NodeNo>
					<xsl:value-of select="MAIN/ZONENO"/>
					<xsl:value-of select="MAIN/BRNO"/>
				</NodeNo>
				<xsl:copy-of select="Head/*"/>
				<BankCode><xsl:value-of select="Head/TranCom/@outcode"/></BankCode>
				<SourceType>8</SourceType>
			</Head>
			<!-- 报文体 -->
			<xsl:apply-templates select="MAIN" />
		</TranData>
	</xsl:template>

	<!-- 报文体 -->
	<xsl:template name="Body" match="MAIN">
		<Body>
			<!-- 投保单号 -->
			<ProposalPrtNo>
				<xsl:value-of select="APPLYNO" />
			</ProposalPrtNo>
			
			<!-- 保单号 -->
			<ContNo>
				<xsl:value-of select="INSURNO" />
			</ContNo>
			<OldLogNo><xsl:value-of select="TRANSCBNO" /></OldLogNo>
		</Body>
	</xsl:template>
</xsl:stylesheet>
