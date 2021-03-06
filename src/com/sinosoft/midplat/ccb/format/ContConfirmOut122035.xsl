<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<Transaction>
	<xsl:copy-of select="TranData/Head" />
     <Transaction_Body>
		<xsl:apply-templates select="TranData/Body" />
	</Transaction_Body>
</Transaction>
</xsl:template>

<xsl:template name="Transaction_Body" match="Body">
<xsl:variable name="MainRisk" select="Risk[RiskCode=MainRiskCode]" />

<PbInsuType>
	<xsl:call-template name="tran_riskcode">
		<xsl:with-param name="riskcode" select="$MainRisk/MainRiskCode" />
	</xsl:call-template>
</PbInsuType>	
<PiEndDate><xsl:value-of select="$MainRisk/InsuEndDate" /></PiEndDate>
<PbFinishDate></PbFinishDate>
<LiDrawstring></LiDrawstring>
<LiCashValueCount>0</LiCashValueCount>	<!-- 建行并不取此处的现价和红利，直接置0 -->
<LiBonusValueCount>0</LiBonusValueCount>
<PbInsuSlipNo><xsl:value-of select="ContNo" /></PbInsuSlipNo>
<BkTotAmt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" /></BkTotAmt>
<LiSureRate></LiSureRate>
<PbBrokId></PbBrokId>
<LiBrokName></LiBrokName>
<LiBrokGroupNo></LiBrokGroupNo>
<BkOthName></BkOthName>
<BkOthAddr></BkOthAddr>
<PiCpicZipcode></PiCpicZipcode>
<PiCpicTelno></PiCpicTelno>
<xsl:if test="$MainRisk/CashValues/CashValue != ''"><!-- 如果有现金价值显示2页 -->
<BkFileNum>2</BkFileNum>
</xsl:if>
<xsl:if test="count($MainRisk/CashValues/CashValue) = 0"><!-- 如果没有现金价值显示1页 -->
<BkFileNum>1</BkFileNum>
</xsl:if>
<Detail_List>
	<BkFileDesc>保单正面</BkFileDesc>
	<BkType1>010058000001</BkType1>	<!-- 重空类型 -->
	<BkVchNo><xsl:value-of select="ContPrtNo" /></BkVchNo>
	<BkRecNum></BkRecNum>	<!-- 此文本的打印行数 【传空，在外面赋值】 -->
	<Detail>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    币值单位：人民币元</xsl:text></BkDetail1>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>
			<xsl:text>　　　投保人姓名：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)" />
			<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Appnt/IDType" />
			<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Appnt/IDNo" />
		</BkDetail1>
		<BkDetail1>
			<xsl:text>　　　被保险人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)" />
			<xsl:text>证件类型：</xsl:text><xsl:apply-templates select="Insured/IDType" />
			<xsl:text>        证件号码：</xsl:text><xsl:value-of select="Insured/IDNo" />
		</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:if test="count(Bnf) = 0">
		<BkDetail1><xsl:text>　　　身故受益人：法定                </xsl:text>
				   <xsl:text>受益顺序：1                   </xsl:text>
				   <xsl:text>受益比例：100%</xsl:text></BkDetail1>
		</xsl:if>
		<xsl:if test="count(Bnf)>0">
		<xsl:for-each select="Bnf">
		<BkDetail1>
			<xsl:text>　　　身故受益人：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
			<xsl:text>受益顺序：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
			<xsl:text>受益比例：</xsl:text><xsl:value-of select="Lot"/><xsl:text>%</xsl:text>
		</BkDetail1>
		</xsl:for-each>
		</xsl:if>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　险种资料</BkDetail1>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1><xsl:text>　　　　　　　　　　                                              基本保险金额\</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>　　　　　　　　　　险种名称              保险期间    交费年期      日津贴额\     保险费    交费频率</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>　　　　　　　　　　                                                份数\档次</xsl:text></BkDetail1>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:for-each select="Risk">
		<xsl:variable name="PayIntv" select="PayIntv"/>
		<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
		<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
		<BkDetail1><xsl:text>　　　</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
								<xsl:choose>
									<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 11)"/>
									</xsl:when>
									<xsl:when test="InsuYearFlag = 'Y'">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 11)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 11)"/>
										<xsl:text></xsl:text>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="PayIntv = 0">
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次性', 10)"/>
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
		</BkDetail1>
		</xsl:for-each>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　保险费合计：<xsl:value-of select="PremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>元整）</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
		<BkDetail1>　　　保险单特别约定：<xsl:choose>
								<xsl:when test="$SpecContent=''">
									<xsl:text>（无）</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$SpecContent"/>
								</xsl:otherwise>
							</xsl:choose></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　-------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>
			<xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></BkDetail1>
		<BkDetail1><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 0)"/></BkDetail1>
		<BkDetail1><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,43)"/><xsl:text>从业资格证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 0)"/></BkDetail1>

	</Detail>
</Detail_List>
<xsl:if test="$MainRisk/CashValues/CashValue != ''">
 <Detail_List>
 	<xsl:variable name="RiskCount" select="count(Risk)"/>
 	<BkFileDesc>保单背面</BkFileDesc>
	<BkType1>010058000001</BkType1>	<!-- 重空类型 -->
	<BkVchNo><xsl:value-of select="ContPrtNo" /></BkVchNo>
	<BkRecNum></BkRecNum>	<!-- 此文本的打印行数 【传空，在外面赋值】 -->
	<Detail>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1><xsl:text>　　　                                        </xsl:text>现金价值表</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </BkDetail1>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></BkDetail1>
	<xsl:if test="$RiskCount=1">
		<BkDetail1>
			<xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></BkDetail1>
		<BkDetail1><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
				   <xsl:text>现金价值</xsl:text></BkDetail1>
		   	<xsl:variable name="EndYear" select="EndYear"/>
		   <xsl:for-each select="$MainRisk/CashValues/CashValue">
			 <xsl:variable name="EndYear" select="EndYear"/>
			   <BkDetail1><xsl:text/><xsl:text>　　　　　</xsl:text>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
										<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</BkDetail1>
			</xsl:for-each>
	 </xsl:if>
	 
	 <xsl:if test="$RiskCount!=1">
	 	<BkDetail1>
			<xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></BkDetail1>
		<BkDetail1><xsl:text/>　　　保单年度末<xsl:text>                                        </xsl:text>
				   <xsl:text>现金价值</xsl:text></BkDetail1>
		   	<xsl:variable name="EndYear" select="EndYear"/>
		   <xsl:for-each select="$MainRisk/CashValues/CashValue">
			 <xsl:variable name="EndYear" select="EndYear"/>
			   <BkDetail1>
					  <xsl:text/><xsl:text>　　　　　</xsl:text>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
					 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</BkDetail1>
			</xsl:for-each>
	 </xsl:if>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
		<BkDetail1></BkDetail1>
		<BkDetail1>　　　备注：</BkDetail1>
		<BkDetail1>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。 </BkDetail1>
		<BkDetail1>　　　------------------------------------------------------------------------------------------------</BkDetail1>
    </Detail>
</Detail_List>
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

<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode='122001'">2001</xsl:when>	<!-- 安邦黄金鼎1号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122002'">2002</xsl:when>	<!-- 安邦黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122003'">2003</xsl:when>	<!-- 安邦聚宝盆1号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122004'">2004</xsl:when>	<!-- 安邦附加黄金鼎2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122005'">2005</xsl:when>	<!-- 安邦黄金鼎3号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122006'">2006</xsl:when>	<!-- 安邦聚宝盆2号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122008'">2008</xsl:when>	<!-- 安邦白玉樽1号终身寿险（万能型） -->
	<xsl:when test="$riskcode='122009'">2009</xsl:when>	<!-- 安邦黄金鼎5号两全保险（分红型）A款 -->
	<xsl:when test="$riskcode='122010'">2010</xsl:when>	<!-- 安邦盛世3号终身寿险（万能型） -->
	
	<xsl:when test="$riskcode='122035'">2035</xsl:when>	<!-- 安邦盛世9号两全保险（万能型） -->
	<xsl:when test="$riskcode='L12052'">2052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
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
