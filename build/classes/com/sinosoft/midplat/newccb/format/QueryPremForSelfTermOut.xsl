<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TX>
	<xsl:copy-of select="TranData/Head" />
	<TX_BODY>
		<ENTITY>
			<APP_ENTITY>
				<xsl:apply-templates select="TranData/Body"/>
			</APP_ENTITY>
		</ENTITY>
	</TX_BODY>
</TX>
</xsl:template>


<xsl:template match="Body">

	<xsl:variable name="tContPlanCode">
		<xsl:value-of select="ContPlan/ContPlanCode" />
	</xsl:variable>
	
	<xsl:variable name="tMainRiskCode">
		<xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskCode" />
	</xsl:variable>
	
	<!-- ���д�����־:1=�����������ı�����0=�ǽ��г��ı��� -->
	<CCB_Agnc_Ind>1</CCB_Agnc_Ind>
	<!-- һ�����к� -->
	<Lv1_Br_No><xsl:value-of select="SubBankCode" /></Lv1_Br_No>
	<!-- �������սɷ�ҵ��ϸ�ִ��� -->
	<AgInsPyFBsnSbdvsn_Cd>
		<xsl:call-template name="tran_AgentPayType">
			<xsl:with-param name="agentPayType" select="AgentPayType" />
		</xsl:call-template>
	</AgInsPyFBsnSbdvsn_Cd>
	
	<!--modify 20150820 Ͷ������ ��һ��2.2�汾����Ҫ����Ͷ������-->
	<Ins_BillNo></Ins_BillNo>
	<!--add 20150820 ��һ��2.2�汾�����ײ����� -->
	<Pkg_Nm></Pkg_Nm>
	<!-- ����ϲ�Ʒ -->					
	<xsl:if test="$tContPlanCode = ''">
		<Cvr_ID>
			<xsl:call-template name="tran_Riskcode">
				<xsl:with-param name="riskcode" select="$tMainRiskCode" />
			</xsl:call-template>
		</Cvr_ID>
		<!--add 20150820 ��һ��2.2�汾������������ -->
	    <Cvr_Nm><xsl:value-of select="Risk[RiskCode=MainRiskCode]/RiskName" /></Cvr_Nm>
	</xsl:if>
	<!-- ��ϲ�Ʒ -->
	<xsl:if test="$tContPlanCode != ''">
		<Cvr_ID>
			<xsl:call-template name="tran_ContPlanCode">
				<xsl:with-param name="contPlanCode" select="$tContPlanCode" />
			</xsl:call-template>
		</Cvr_ID>
		<!--add 20150820 ��һ��2.2�汾������������ -->
	    <Cvr_Nm><xsl:value-of select="ContPlan/ContPlanName" /></Cvr_Nm>
	</xsl:if>
	
	<!-- �ײͱ��� -->
	<AgIns_Pkg_ID></AgIns_Pkg_ID>
	<!--modify 20150820 �������� ��һ��2.2�汾����Ҫ���ر�����--> 
	<InsPolcy_No></InsPolcy_No>
	<!-- Ͷ�������� -->
	<Plchd_Nm><xsl:value-of select="Appnt/Name" /></Plchd_Nm>
	<!-- ����Ӧ������ -->
	<Rnew_Pbl_Dt><xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.date10to8(Risk[RiskCode=MainRiskCode]/StartPayDate)" /></Rnew_Pbl_Dt>
	<!-- ���սɷѽ�� -->
	<Ins_PyF_Amt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)" /></Ins_PyF_Amt>
	<!-- ����Ӧ������ -->
	<Rnew_Pbl_Prd_Num><xsl:value-of select="(Risk[RiskCode=MainRiskCode]/PayTotalCount)-(Risk[RiskCode=MainRiskCode]/PayCount) " /></Rnew_Pbl_Prd_Num>
				
</xsl:template>


<!-- �������սɷ�ҵ��ϸ�ִ��� 01-ʵʱͶ���ɷ� 02-��ʵʱͶ���ɷ� 03-���ڽ��� -->
<xsl:template name="tran_AgentPayType">
	<xsl:param name="agentPayType" />
	<xsl:choose>
		<xsl:when test="$agentPayType='01'">11</xsl:when>	<!-- ʵʱͶ���ɷ� -->
		<xsl:when test="$agentPayType='02'">12</xsl:when>	<!-- ��ʵʱͶ���ɷ� -->
		<xsl:when test="$agentPayType='03'">14</xsl:when>	<!-- ���ڽ��� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

		
<!-- ���ִ��� -->
<xsl:template name="tran_Riskcode">
	<xsl:param name="riskcode" />
	<xsl:choose>

		<xsl:when test="$riskcode='L12080'">L12080</xsl:when> 	<!-- ����ʢ��1���������գ������ͣ�A -->
		
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
	<xsl:choose>
		<xsl:when test="$contPlanCode=50015">50002</xsl:when>	<!-- �������Ӯ���ռƻ� -->
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
