<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/TranData">
<INSUREQRET>
	<xsl:copy-of select="Head" />
	<!-- 主信息 -->
	<MAIN>
		<CORP_DEPNO></CORP_DEPNO>
		<CORP_AGENTNO></CORP_AGENTNO>
		<POLICY><xsl:value-of select="Body/ContNo"/></POLICY>
		<INSUREAMT><xsl:value-of select="Body/Prem" /></INSUREAMT>
    </MAIN>
	<xsl:apply-templates select="Body" />
</INSUREQRET>
</xsl:template>

<!-- 打印信息 -->
<xsl:template name="PRINT" match="Body">
	<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />
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
		<PRINT_LINE><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    币值单位：人民币元</xsl:text></PRINT_LINE>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>
			<xsl:text>　　　投保人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
			<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Appnt/IDType" />
			<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Appnt/IDNo" />
		</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>
			<xsl:text>　　　被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
			<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Insured/IDType" />
			<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Insured/IDNo" />
		</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		<xsl:if test="count(Bnf) = 0">
		<PRINT_LINE><xsl:text>　　　身故受益人：法定                </xsl:text>
				   <xsl:text>受益顺序：1                   </xsl:text>
				   <xsl:text>受益比例：100%</xsl:text></PRINT_LINE>
		</xsl:if>
		<xsl:if test="count(Bnf)>0">
		<xsl:for-each select="Bnf">
		<PRINT_LINE>
			<xsl:text>　　　身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
			<xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
			<xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
		</PRINT_LINE>
		</xsl:for-each>
		</xsl:if>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　险种资料</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　      基本保险金额\</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>　　　        险种名称                       保险期间    交费年期   日津贴额\       保险费      交费频率</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>
					<xsl:text>　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　      份数\档次</xsl:text>
				</PRINT_LINE>
				<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		
		<xsl:for-each select="Risk">
		<xsl:variable name="PayIntv" select="PayIntv"/>
		<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
		<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
		<PRINT_LINE><xsl:text>　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 8)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 8)"/>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次交清', 12)"/>
									</xsl:when>
									<xsl:when test="PayEndYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 10)"/>
									</xsl:when>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('保单帐户价值',15)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Amnt,15)"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($Prem,13)"/>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:text>趸缴</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 12">
										<xsl:text>年缴</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 6">
										<xsl:text>半年缴</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 3">
										<xsl:text>季缴</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = 1">
										<xsl:text>月缴</xsl:text>
									</xsl:when>
									<xsl:when test="PayIntv = -1">
										<xsl:text>不定期缴</xsl:text>
									</xsl:when>
								</xsl:choose>
		</PRINT_LINE>
		</xsl:for-each>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　保险费合计：<xsl:value-of select="PremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>元整）</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
		<PRINT_LINE>　　　保险单特别约定：<xsl:choose>
								<xsl:when test="$SpecContent=''">
									<xsl:text>（无）</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$SpecContent"/>
								</xsl:otherwise>
							</xsl:choose></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　-------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>
			<xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName,49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo, 0)"/></PRINT_LINE>
		
	</PRINT>
    <xsl:if test="$MainRisk/CashValues/CashValue != ''">
    <xsl:variable name="RiskCount" select="count(Risk)"/>
	<PRINT>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text>　　　                                        </xsl:text>现金价值表</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </PRINT_LINE>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
	<xsl:if test="$RiskCount=1">
		<PRINT_LINE>
			<xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PRINT_LINE>
			<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
				   <xsl:text>现金价值</xsl:text></PRINT_LINE>
		   	<xsl:variable name="EndYear" select="EndYear"/>
		   <xsl:for-each select="$MainRisk/CashValues/CashValue">
		   <PRINT_LINE></PRINT_LINE>
			 <xsl:variable name="EndYear" select="EndYear"/>
			   <PRINT_LINE><xsl:text/><xsl:text>　　　　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</PRINT_LINE>
			</xsl:for-each>
	 </xsl:if>
	 
	 <xsl:if test="$RiskCount!=1">
	 	<PRINT_LINE>
			<xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>	
		<PRINT_LINE><xsl:text/>　　　保单年度末<xsl:text>                                        </xsl:text>
				   <xsl:text>现金价值</xsl:text></PRINT_LINE>
		   	<xsl:variable name="EndYear" select="EndYear"/>
		   <xsl:for-each select="$MainRisk/CashValues/CashValue">
		   <PRINT_LINE></PRINT_LINE>
			 <xsl:variable name="EndYear" select="EndYear"/>
			   <PRINT_LINE>
					  <xsl:text/><xsl:text>　　　　　</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</PRINT_LINE>
			</xsl:for-each>
	 </xsl:if>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　备注：</PRINT_LINE>
		<PRINT_LINE></PRINT_LINE>
		<PRINT_LINE>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。 </PRINT_LINE>
		<PRINT_LINE>　　　------------------------------------------------------------------------------------------------</PRINT_LINE>
    </PRINT>
    </xsl:if>
</xsl:template>

<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
<xsl:template match="IDType">
<xsl:choose>
	<xsl:when test=".=0">身份证</xsl:when>
	<xsl:when test=".=1">护照  </xsl:when>
	<xsl:when test=".=2">军官证</xsl:when>
	<xsl:when test=".=3">驾照  </xsl:when>
	<xsl:when test=".=5">户口簿</xsl:when>
	<xsl:otherwise>--  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 缴费间隔  -->
<xsl:template match="PayIntv">
<xsl:choose>
	<xsl:when test=".=0">一次交清</xsl:when>		
	<xsl:when test=".=1">月交</xsl:when>
	<xsl:when test=".=3">季交</xsl:when>
	<xsl:when test=".=6">半年交</xsl:when>
	<xsl:when test=".=12">年交</xsl:when>
	<xsl:when test=".=-1">不定期交</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
 
 <!-- 性别【注意：“男     ”空格排版用的，不能去掉】-->
<xsl:template match="Sex">
<xsl:choose>
	<xsl:when test=".=0">男  </xsl:when>		
	<xsl:when test=".=1">女  </xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 险种代码 -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=122006">2006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=122008">2008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
	<xsl:when test="$riskcode=122009">2009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode=L12080">L12080</xsl:when>	<!--  -->
	<xsl:when test="$riskcode=L12087">L12087</xsl:when>	<!-- 安邦东风5号两全保险（万能型） -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- 红利领取  -->
<xsl:template match="Risk[RiskCode=MainRiskCode]/BonusGetMode">
<xsl:choose>
	<xsl:when test=".=1">累计生息</xsl:when>
	<xsl:when test=".=2">领取现金</xsl:when>
	<xsl:when test=".=3">抵缴保费</xsl:when>
	<xsl:when test=".=5">增额交清</xsl:when>
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
