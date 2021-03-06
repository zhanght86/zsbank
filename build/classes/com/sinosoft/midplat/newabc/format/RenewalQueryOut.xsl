<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	
	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<xsl:apply-templates select="Body" />
		</TranData>
	</xsl:template>
	
	<!--报文体信息-->
	<xsl:template match="Body">
		<App>
			<Ret>
				<!--投保人信息-->
				<Appl>
					<!--投保人姓名-->
					<Name><xsl:value-of select="PubContInfo/AppntName" /></Name>
					<!--证件类型-->
					<IDKind><xsl:apply-templates select="PubContInfo/AppntIDType" /></IDKind>
					<!--证件号码-->
					<IDCode><xsl:value-of select="PubContInfo/AppntIDNo" /></IDCode>
				</Appl>
				<!--应缴期数-->
				<DuePeriod><xsl:value-of select="EdorXQInfo/PaymentTimes" /></DuePeriod>
				<!--应缴日期-->
				<DueDate><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(EdorXQInfo/FinEffDate)" /></DueDate>
				<!--应缴金额-->
				<DueAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EdorXQInfo/FinActivityGrossAmt)" /></DueAmt>
				<!--保险公司方险种代码-->
				<RiskCode><xsl:apply-templates select="PubContInfo/MainRiskCode"  mode="risk"/></RiskCode>
				<!--保单号-->
				<PolicyNo><xsl:value-of select="PubContInfo/ContNo" /></PolicyNo>
			</Ret>
		</App>
	</xsl:template>

    <!-- 证件类型 -->
	<xsl:template  match="AppntIDType">
		<xsl:choose>
			<xsl:when test=".=0">110001</xsl:when><!-- 身份证 -->
			<xsl:when test=".=1">110023</xsl:when><!-- 护照 -->
			<xsl:when test=".=2">110027</xsl:when><!-- 军官证 -->
			<xsl:when test=".=3">119999</xsl:when><!-- 其他  -->
			<xsl:when test=".=4">119999</xsl:when><!-- 出生证明  -->
			<xsl:when test=".=5">110019</xsl:when><!-- 港澳通行证  -->
			<xsl:when test=".=6">110003</xsl:when><!-- 临时身份证  -->
			<xsl:when test=".=7">110033</xsl:when><!-- 士兵证  -->
			<xsl:when test=".=8">110021</xsl:when><!-- 台胞证  -->
			<xsl:when test=".=9">110005</xsl:when><!-- 户口本  -->
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 险种代码 -->
	<xsl:template  match="MainRiskCode"  mode="risk">
		<xsl:choose>
			<!-- FIXME 这个地方测试时要留意看核心返回的50001，和500015对应的险种码是什么? -->
			<xsl:when test=".='122046'">122046</xsl:when><!-- 长寿稳赢1号套餐 -->
			
			<xsl:when test=".='50015'">50015</xsl:when><!-- 长寿稳赢保险计划 -->
			<xsl:when test=".='L12079'">L12079</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12078'">L12078</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更start -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<!-- 盛世3号产品代码变更end -->
			<xsl:when test=".='L12074'">L12074</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号两全保险（万能型）B款  -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号两全保险（万能型）  -->
			
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<xsl:when test=".='122036'">122036</xsl:when><!-- 安邦黄金鼎6号两全保险（分红型）A款  -->
			
			<xsl:when test=".='122006'">122006</xsl:when><!-- 安邦聚宝盆2号两全保险（分红型）A款  -->
			<xsl:when test=".='122008'">122008</xsl:when><!-- 安邦白玉樽1号终身寿险(万能型)  -->
			<xsl:when test=".='122002'">122002</xsl:when><!-- 安邦黄金鼎2号两全保险(分红型)A款  -->
			<xsl:when test=".='122005'">122005</xsl:when><!-- 安邦黄金鼎3号两全保险(分红型)A款  -->
			
			<!-- 新险种代码上线后，会存在险种代码并存的情况 -->
			<xsl:when test=".='50002'">50002</xsl:when><!-- 长寿稳赢保险计划 -->
			<xsl:when test=".='122012'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='122010'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型）  -->
			<xsl:when test=".='122035'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型）  -->
			
			<!-- 安邦长寿安享5号保险计划50012,安邦长寿安享5号年金保险L12070,安邦附加长寿添利5号两全保险（万能型）L12071 -->
			<xsl:when test=".='50012'">50012</xsl:when>
			
			<!--  安邦东风3号两全保险（万能型）L12086 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
