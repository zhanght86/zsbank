<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
	 <TranData>
		<Head>
			<xsl:copy-of select="TX/Head/*"/>
		</Head>
		<Body>
			<xsl:apply-templates select="TX/TX_BODY/ENTITY/APP_ENTITY"/>
		</Body>
	</TranData>
</xsl:template>


<xsl:template name="Body" match="APP_ENTITY">
	
	<!-- 投保单号 -->
	<ProposalPrtNo />
	<!-- 保单号 寿险保单号标签：ContNo。保单印刷号（单证号）：ContPrtNo-->
	<ContNo />
	<!-- 单证号 -->
	<ContPrtNo />
	
	<OldTranNo><xsl:value-of select="Orig_TxnSrlNo"/></OldTranNo>
	<ServiceType></ServiceType><!--1:缴费冲正  2：保单打印冲正-->
</xsl:template>

</xsl:stylesheet>



