<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/TranData">
<INSUREQRET>
	<xsl:copy-of select="Head" />
	<!-- ����Ϣ -->
	<MAIN>
		<CORP_DEPNO></CORP_DEPNO>
		<CORP_AGENTNO></CORP_AGENTNO>
		<POLICY><xsl:value-of select="Body/ContNo"/></POLICY>
		<INSUREAMT><xsl:value-of select="Body/ActSumPrem" /></INSUREAMT>
    </MAIN>
	<xsl:apply-templates select="Body" />
</INSUREQRET>
</xsl:template>

<!-- ��ӡ��Ϣ -->
<xsl:template name="PRINT" match="Body">
	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
	<xsl:variable name="leftPadFlag" select="java:java.lang.Boolean.parseBoolean('true')" />
    <xsl:variable name="ContPlanMultWith0" select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith0(ContPlan/ContPlanMult,5,$leftPadFlag)"/>

	
	<PRINT>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>���������յ����룺</xsl:text><xsl:value-of select="ContNo" /><xsl:text>-(00001��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat($ContPlanMultWith0,')'),5)" /><xsl:text>                                      ��ֵ��λ�������Ԫ</xsl:text></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>
			<xsl:text>������Ͷ����������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
			<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Appnt/IDType" />
			<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Appnt/IDNo" />
		</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>
			<xsl:text>�������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
			<xsl:text>֤�����ͣ�</xsl:text><xsl:apply-templates select="Insured/IDType" />
			<xsl:text>        ֤�����룺</xsl:text><xsl:value-of select="Insured/IDNo" />
		</PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<xsl:if test="count(Bnf) = 0">
		<PRINT_LINE><xsl:text>���������������ˣ�����                </xsl:text>
				   <xsl:text>����˳��1                   </xsl:text>
				   <xsl:text>���������100%</xsl:text></PRINT_LINE>
		</xsl:if>
		<xsl:if test="count(Bnf)>0">
		<xsl:for-each select="Bnf">
		<PRINT_LINE>
			<xsl:text>���������������ˣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
			<xsl:text>����˳��</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
			<xsl:text>���������</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
		</PRINT_LINE>
		</xsl:for-each>
		</xsl:if>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>��������������</PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE><xsl:text>��������������������                                               �������ս��\</xsl:text></PRINT_LINE>
		<PRINT_LINE><xsl:text>����������������������������                �����ڼ�    ��������     �ս�����\    ���շ�    ����Ƶ��</xsl:text></PRINT_LINE>
		<PRINT_LINE><xsl:text>��������������������                                                 ����\����</xsl:text></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<xsl:for-each select="Risk">
		<xsl:variable name="PayIntv" select="PayIntv"/>
		<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
		<xsl:variable name="ActPrem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActPrem)"/>
		<PRINT_LINE>
			<xsl:choose>
			<xsl:when test="RiskCode='L12081'">
				<xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-', 12)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 14)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('-',13)"/>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:text>-</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 12">
										<xsl:text>���</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 6">
										<xsl:text>�����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 3">
										<xsl:text>����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 1">
										<xsl:text>�½�</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = -1">
										<xsl:text>�����ڽ�</xsl:text>
									</xsl:when>
								</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>������</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('����', 11)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '��'), 11)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '����'), 11)"/>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('һ����', 12)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '��'), 12)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('�����ʻ���ֵ',13)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,13)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($ActPrem,13)"/>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:text>����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 12">
										<xsl:text>���</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 6">
										<xsl:text>�����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 3">
										<xsl:text>����</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 1">
										<xsl:text>�½�</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = -1">
										<xsl:text>�����ڽ�</xsl:text>
									</xsl:when>
								</xsl:choose>
			</xsl:otherwise>
			</xsl:choose>
		</PRINT_LINE>
		</xsl:for-each>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>���������շѺϼƣ�<xsl:value-of select="ActSumPremText" />��RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(ActSumPrem)"/>Ԫ����</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<xsl:variable name="SpecContent" select="SpecContent"/>
		<PRINT_LINE>������<xsl:text>���յ��ر�Լ����</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
				<xsl:choose>
					<xsl:when test="$SpecContent=''">
						<xsl:text>���ޣ�</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<PRINT_LINE><xsl:text>������    ������ı��ղ�ƷΪ���������Ӯ���ռƻ����������ڱ��պ�ͬ��Ч�������˱�������˾���˻����յ�</xsl:text></PRINT_LINE>
						<PRINT_LINE></PRINT_LINE>
						<PRINT_LINE><xsl:text>�������ֽ��ֵ��</xsl:text></PRINT_LINE>
						<PRINT_LINE></PRINT_LINE>
						<PRINT_LINE><xsl:text>������    ���������Ӯ1����ȫ���յ����ͬԼ����������ʱ�������պ�ͬЧ����ֹ�������պ�ͬͬʱ��ֹ������</xsl:text></PRINT_LINE>
						<PRINT_LINE></PRINT_LINE>
						<PRINT_LINE><xsl:text>�����������պ�ͬ�������պ�ͬ�������ڱ��ս�֮�͵�101.5%�Ľ��Զ�ת�밲��������������գ������ͣ���</xsl:text></PRINT_LINE>
						<PRINT_LINE></PRINT_LINE>
						<PRINT_LINE><xsl:text>�����������˻��У��������պ�ͬ�����������Զ�ת�������ʱ����Ч��</xsl:text></PRINT_LINE>
						
					</xsl:otherwise>
				</xsl:choose>
		<PRINT_LINE>������-------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>
			<xsl:text>���������պ�ͬ�������ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>��<xsl:text>                               ���պ�ͬ��Ч���ڣ�</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>��<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>��</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>������Ӫҵ������</xsl:text><xsl:value-of select="ComName" /></PRINT_LINE>
		<PRINT_LINE><xsl:text>������Ӫҵ��ַ��</xsl:text><xsl:value-of select="ComLocation" /></PRINT_LINE>
		<PRINT_LINE><xsl:text>�������ͻ��������ߣ�95569                                            ��ַ��http://www.anbang-life.com</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>������Ϊȷ�����ı���Ȩ�棬�뼰ʱ�����ҹ�˾����绰����½��վ�򵽹�̨���в�ѯ����ʵ������Ϣ�����ڱ�����</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>��������һ�������ϵ����ձ��������������յ�����֮����10��������״β�ѯ����</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>�����������������ƣ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName,49)"/><xsl:text>����������Ա���ţ�</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 0)"/></PRINT_LINE>
		
	</PRINT>

    <xsl:variable name="RiskCount" select="count(Risk)"/>
    <xsl:variable name="printmult1" select="concat('-(00001��',$ContPlanMultWith0)"/>
 	<xsl:variable name="printmult2" select="concat($printmult1,')')"/>
	<PRINT>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>������                                        </xsl:text>�ֽ��ֵ��</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>���������յ����룺<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(ContNo,$printmult2), 60)"/>��ֵ��λ�������Ԫ </PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>��������������������<xsl:value-of select="Insured/Name"/></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
	<xsl:if test="$RiskCount=1">
		<PRINT_LINE>
			<xsl:text>�������������ƣ�                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRINT_LINE>
			<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text/>�������������ĩ<xsl:text>                              </xsl:text>
				   <xsl:text>�ֽ��ֵ</xsl:text></PRINT_LINE>
		   	<xsl:variable name="EndYear" select="EndYear"/>
		   <xsl:for-each select="$MainRisk/CashValues/CashValue">
		   <PRINT_LINE></PRINT_LINE>
			 <xsl:variable name="EndYear" select="EndYear"/>
			   <PRINT_LINE><xsl:text/><xsl:text>����������</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>Ԫ</PRINT_LINE>
			</xsl:for-each>
	 </xsl:if>
	 
	 <xsl:if test="$RiskCount!=1">
	 	<PRINT_LINE>
			<xsl:text>�������������ƣ�              </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>	
		<PRINT_LINE><xsl:text>�������������ĩ��������������������  �ֽ��ֵ��������������������  ����      �ֽ��ֵ</xsl:text></PRINT_LINE>
		   	<xsl:variable name="EndYear" select="EndYear"/>
		   <xsl:for-each select="$MainRisk/CashValues/CashValue">
		   <PRINT_LINE></PRINT_LINE>
			 <xsl:variable name="EndYear" select="EndYear"/>
			   <PRINT_LINE>
					  <xsl:text/><xsl:text>����������</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), 'Ԫ'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>Ԫ</PRINT_LINE>
			</xsl:for-each>
	 </xsl:if>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>��������ע��</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>�����������ֽ��ֵΪ��Ӧ�������ĩ��ֵ����������ڵ��ֽ��ֵ���������򱾹�˾��ѯ�� </PRINT_LINE>
		<PRINT_LINE>������------------------------------------------------------------------------------------------------</PRINT_LINE>
    </PRINT>
</xsl:template>

<!-- ֤�����͡�ע�⣺������  ���ո��Ű��õģ�����ȥ���� -->
<xsl:template match="IDType">
	<xsl:choose>
		<xsl:when test=".=0">����֤</xsl:when>
		<xsl:when test=".=1">����  </xsl:when>
		<xsl:when test=".=2">����֤</xsl:when>
		<xsl:when test=".=3">����  </xsl:when>
		<xsl:when test=".=5">���ڲ�</xsl:when>
		<xsl:otherwise>--  </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- �ɷѼ��  -->
<xsl:template match="PayIntv">
	<xsl:choose>
		<xsl:when test=".=0">һ�ν���</xsl:when>		
		<xsl:when test=".=1">�½�</xsl:when>
		<xsl:when test=".=3">����</xsl:when>
		<xsl:when test=".=6">���꽻</xsl:when>
		<xsl:when test=".=12">�꽻</xsl:when>
		<xsl:when test=".=-1">�����ڽ�</xsl:when>
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
 
 <!-- �Ա�ע�⣺����     ���ո��Ű��õģ�����ȥ����-->
<xsl:template match="Sex">
	<xsl:choose>
		<xsl:when test=".=0">��  </xsl:when>		
		<xsl:when test=".=1">Ů  </xsl:when>
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ������ȡ  -->
<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
	<xsl:choose>
		<xsl:when test=".=1">�ۼ���Ϣ</xsl:when>
		<xsl:when test=".=2">��ȡ�ֽ�</xsl:when>
		<xsl:when test=".=3">�ֽɱ���</xsl:when>
		<xsl:when test=".=5">�����</xsl:when>
		<xsl:otherwise>--</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>