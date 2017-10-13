<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:template match="/">
		<TXLife>
			<xsl:copy-of select="TranData/Head" />
			<TXLifeResponse>
				<xsl:if test="TranData/Head/Flag='0'">
					<xsl:apply-templates select="TranData/Body" />
				</xsl:if>
			</TXLifeResponse>
		</TXLife>
	</xsl:template>

	<xsl:template name="OLife" match="Body">
		<xsl:variable name="MainRisk"
			select="Risk[RiskCode=MainRiskCode]" />
		<OLife>
			<Holding id="Holding_1">
				<!-- 保单信息 -->
				<Policy>
					<!-- 保单号ContNo -->
					<PolNumber>
						<xsl:value-of select="ContNo" />
					</PolNumber>
					<!-- 主险代码 -->
					<ProductCode>
						<xsl:apply-templates select="$MainRisk/RiskCode" />
					</ProductCode>
					<!--  交费方式  -->
					<PaymentMode>
						<xsl:call-template name="tran_PayIntv">
							<xsl:with-param name="PayIntv">
								<xsl:value-of
									select="$MainRisk/PayIntv" />
							</xsl:with-param>
						</xsl:call-template>
					</PaymentMode>
					<!-- 保险合同生效日期 -->
					<EffDate>
						<xsl:value-of select="$MainRisk/CValiDate" />
					</EffDate>
					<!-- 承保日期 -->
					<IssueDate>
						<xsl:value-of select="$MainRisk/SignDate" />
					</IssueDate>
					<!--  中止日期  -->
					<TermDate>
						<xsl:value-of select="$MainRisk/InsuEndDate" />
					</TermDate>
					<!--  交费终止日期  -->
					<FinalPaymentDate>
						<xsl:value-of select="$MainRisk/PayEndDate" />
					</FinalPaymentDate>
					<!--首期保费-->
					<PaymentAmt>
						<xsl:value-of
							select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
					</PaymentAmt>
					<!--  交费形式（T：转账）  -->
					<PaymentMethod tc="T">T</PaymentMethod>
					<Life>
						<xsl:apply-templates select="Risk" />
					</Life>
				</Policy>
			</Holding>

			<Party id="CAR_PTY_1">
				<FullName>安邦人寿保险股份有限公司</FullName>
				<!--  保险公司名称  -->
			</Party>

			<Relation OriginatingObjectID="Holding_1"
				RelatedObjectID="CAR_PTY_1" id="RLN_HLDP_1C">
				<OriginatingObjectType tc="4">4</OriginatingObjectType>
				<RelatedObjectType tc="6">6</RelatedObjectType>
				<RelationRoleCode tc="87">87</RelationRoleCode>
				<!--  承保公司关系  -->
			</Relation>


			<!--保单逐行打印接口-->
			<OLifeExtension>
				<BasePlanPrintInfos id="BaseInfos">
				<ContPrint>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo><xsl:text>　　　保险单号码：</xsl:text><xsl:value-of select="ContNo" /><xsl:text>                                                    币值单位：人民币元</xsl:text></PrintInfo>
					<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo>
						<xsl:text>　　　投保人姓名：</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Appnt/Name, 29)"/>
						<xsl:text>证件类型：</xsl:text>
						<xsl:apply-templates select="Appnt/IDType"/>
						<xsl:text>        证件号码：</xsl:text>
						<xsl:value-of select="Appnt/IDNo"/>
					</PrintInfo>
					<PrintInfo>
						<xsl:text>　　　被保险人：</xsl:text>
						<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Insured/Name, 31)"/>
						<xsl:text>证件类型：</xsl:text>
						<xsl:apply-templates select="Insured/IDType"/>
						<xsl:text>        证件号码：</xsl:text>
						<xsl:value-of select="Insured/IDNo"/>
					</PrintInfo>
					<PrintInfo/>
					<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
					<xsl:if test="count(Bnf) = 0">
					<PrintInfo><xsl:text>　　　身故受益人：法定                </xsl:text>
					   <xsl:text>受益顺序：1                   </xsl:text>
					   <xsl:text>受益比例：100%</xsl:text></PrintInfo>
			        </xsl:if>
					<xsl:if test="count(Bnf)>0">
						<xsl:for-each select="Bnf">
							<PrintInfo>
								<xsl:text>　　　身故受益人：</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Name, 20)"/>
								<xsl:text>受益顺序：</xsl:text>
								<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(Grade, 16)"/>
								<xsl:text>受益比例：</xsl:text>
								<xsl:value-of select="Lot"/>
								<xsl:text>%</xsl:text>
							</PrintInfo>
						</xsl:for-each>
					</xsl:if>
					<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo/>
					<PrintInfo>　　　险种资料</PrintInfo>
					<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo>
						<xsl:text>　　　　　　　　　　险种名称               保险期间    交费年期    基本保险金额    保险费    交费频率</xsl:text>
					</PrintInfo>
					<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
					<xsl:for-each select="Risk">
						<xsl:variable name="PayIntv" select="PayIntv"/>
						<xsl:variable name="Amnt" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)"/>
						<xsl:variable name="Prem" select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>
						<PrintInfo>
							<xsl:text>　　　</xsl:text>
							<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(RiskName, 40)"/>
							<xsl:choose>
								<xsl:when test="(InsuYear = 106) and (InsuYearFlag = 'A')">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('终身', 9)"/>
								</xsl:when>
								<xsl:when test="InsuYearFlag = 'Y'">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '年'), 9)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(InsuYear, '周岁'), 9)"/>
									<xsl:text/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="PayIntv = 0">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_('一次交清', 12)"/>
								</xsl:when>
								<xsl:when test="PayEndYearFlag = 'Y'">
									<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(PayEndYear, '年'), 12)"/>
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
						</PrintInfo>
					</xsl:for-each>
					<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo/>
					<PrintInfo>　　　保险费合计：<xsl:value-of select="PremText" />（RMB<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)"/>元整）</PrintInfo>
					<PrintInfo/>
					<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo/>
					<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
					<xsl:variable name="SpecContent" select="Risk[RiskCode=MainRiskCode]/SpecContent"/>
					<!-- PBKINSR-506 招行银保通、网银新增证件类型 -->
					<xsl:variable name="AppIDType" select="Appnt/IDType"/>
					<xsl:variable name="InsIDType" select="Insured/IDType"/>
					<PrintInfo>　　　保险单特别约定：<xsl:choose>
							<xsl:when test="$SpecContent!='' or $AppIDType='6' or $AppIDType='7' or $InsIDType='6' or $InsIDType='7'">
								<xsl:value-of select="$SpecContent"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>（无）</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</PrintInfo>
					<xsl:choose>
					<xsl:when test="$AppIDType='6' or $AppIDType='7' or $InsIDType='6' or $InsIDType='7'">
						<PrintInfo>
							<xsl:text>　　　    本合同中提到的‘港澳回乡证’为‘港澳居民来往大陆通行证’简称，本合同中提到的‘台胞证’为‘台</xsl:text>									
						</PrintInfo>
						<PrintInfo>
							<xsl:text>　　　湾居民来往大陆通行证’简称。</xsl:text>
						</PrintInfo>
					</xsl:when>
					<xsl:otherwise>
						<PrintInfo/>
						<PrintInfo/>
					</xsl:otherwise>
					</xsl:choose>
					<!-- PBKINSR-506 招行银保通、网银新增证件类型 -->
					<PrintInfo/>
					<PrintInfo>　　　-------------------------------------------------------------------------------------------------</PrintInfo>
					<PrintInfo><xsl:text>　　　保险合同成立日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/PolApplyDate,7,2)"/>日<xsl:text>                               保险合同生效日期：</xsl:text><xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,1,4)"/>年<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,5,2)"/>月<xsl:value-of  select="substring(Risk[RiskCode=MainRiskCode]/CValiDate,7,2)"/>日</PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>　　　营业机构：</xsl:text><xsl:value-of select="ComName" /></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>　　　营业地址：</xsl:text><xsl:value-of select="ComLocation" /></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>　　　客户服务热线：95569                                            网址：http://www.anbang-life.com</xsl:text></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>　　　为确保您的保单权益，请及时拨打我公司服务电话、登陆网站或到柜台进行查询，核实保单信息（对于保险期</xsl:text></PrintInfo>
					<PrintInfo><xsl:text>　　　限一年期以上的寿险保单，建议您在收到保单之日起10日内完成首次查询）。</xsl:text></PrintInfo>
					<PrintInfo></PrintInfo>
					<PrintInfo><xsl:text>　　　银行网点名称：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(AgentComName, 49)"/><xsl:text>银行销售人员工号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(SellerNo,0)"/></PrintInfo>
					<PrintInfo><xsl:text>　　　银行销售人员：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerName,49)"/><xsl:text>从业资格证编号：</xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(TellerCertiCode, 0)"/></PrintInfo>
					
				</ContPrint>
				<CashValue>
				 	<!-- 当有现金价值时，打印现金价值 -->
					<xsl:if test="$MainRisk/CashValues/CashValue != ''">
						<xsl:variable name="RiskCount" select="count(Risk)"/>
					    <PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo/>
						<PrintInfo><xsl:text>　　　                                        </xsl:text>现金价值表</PrintInfo>
						<PrintInfo/>
						<PrintInfo>　　　保险单号码：<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(ContNo, 60)"/>币值单位：人民币元 </PrintInfo>
						<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
						<PrintInfo>　　　被保险人姓名：<xsl:value-of select="Insured/Name"/></PrintInfo>
		                <xsl:if test="$RiskCount=1">
				        <PrintInfo>
					    <xsl:text>　　　险种名称：                  </xsl:text><xsl:value-of select="$MainRisk/RiskName"/></PrintInfo>
				        <PrintInfo><xsl:text/>　　　保单年度末<xsl:text>                              </xsl:text>
						   <xsl:text>现金价值</xsl:text></PrintInfo>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <PrintInfo><xsl:text/><xsl:text>　　　　　</xsl:text>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,36)"/>
												<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)"/>元</PrintInfo>
					    </xsl:for-each>
			            </xsl:if>
			 
			            <xsl:if test="$RiskCount!=1">
			 	        <PrintInfo>
					    <xsl:text>　　　险种名称：          </xsl:text><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_($MainRisk/RiskName,38)"/><xsl:value-of select="Risk[RiskCode!=MainRiskCode]/RiskName"/></PrintInfo>
				        <PrintInfo><xsl:text/>　　　保单年度末<xsl:text>                                        </xsl:text>
						   <xsl:text>现金价值</xsl:text></PrintInfo>
				   	       <xsl:variable name="EndYear" select="EndYear"/>
				        <xsl:for-each select="$MainRisk/CashValues/CashValue">
					    <xsl:variable name="EndYear" select="EndYear"/>
					    <PrintInfo>
							 <xsl:text/><xsl:text>　　　　　</xsl:text>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(EndYear,28)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fillStrWith_(concat(java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash), '元'),40)"/>
							 <xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(../../../Risk[RiskCode!=MainRiskCode]/CashValues/CashValue[EndYear=$EndYear]/Cash)"/>元</PrintInfo>
					    </xsl:for-each>
			            </xsl:if>
						<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>
						<PrintInfo/>
						<PrintInfo>　　　备注：</PrintInfo>
						<PrintInfo>　　　所列现金价值为对应保单年度末的值，保单年度内的现金价值，您可以向本公司咨询。</PrintInfo>
						<PrintInfo>　　　------------------------------------------------------------------------------------------------</PrintInfo>	
					</xsl:if>
				</CashValue>				
				</BasePlanPrintInfos>
			</OLifeExtension>
		</OLife>
	</xsl:template>

	<!-- 险种信息 -->
	<xsl:template name="Coverage" match="Risk">
			<xsl:variable name="RiskId"
			select="concat('Cov_', string(position()))" />
		<Coverage>
			<xsl:attribute name="id"><xsl:value-of select="$RiskId" />
			</xsl:attribute>
			<!-- 险种名称 -->
			<PlanName>
				<xsl:value-of select="RiskName" />
			</PlanName>
			<!-- 险种代码 -->
			<ProductCode>
				<xsl:apply-templates select="RiskCode" />
			</ProductCode>
			<!-- 主副险标志 -->
			<xsl:choose>
				<xsl:when test="RiskCode=MainRiskCode">
					<IndicatorCode tc="1">1</IndicatorCode>
				</xsl:when><!-- 主险标志 -->
				<xsl:otherwise>
					<IndicatorCode tc="2">2</IndicatorCode>
				</xsl:otherwise><!-- 副险标志 -->
			</xsl:choose>
			<!-- 缴费方式 频次 -->
			<PaymentMode>
				<xsl:call-template name="tran_PayIntv">
					<xsl:with-param name="PayIntv">
						<xsl:value-of select="PayIntv" />
					</xsl:with-param>
				</xsl:call-template>
			</PaymentMode>
			<!-- 投保金额 -->
			<InitCovAmt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Amnt)" />
			</InitCovAmt>
			<!-- 投保份额 -->
			<IntialNumberOfUnits>
				<xsl:value-of select="Mult" />
			</IntialNumberOfUnits>
			<!-- 险种保费 -->
			<ChargeTotalAmt>
				<xsl:value-of
					select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Prem)" />
			</ChargeTotalAmt>
			<OLifeExtension>
				<!--  交费年期/年龄类型  -->
				<!--  交费年期/年龄（数字类型，不能为空）  -->
				<xsl:choose>
					<xsl:when test="PayIntv = '0'">
						<PaymentDurationMode>Y</PaymentDurationMode>
						<PaymentDuration>0</PaymentDuration>
					</xsl:when><!--  趸交  -->
					<xsl:otherwise>
						<PaymentDurationMode>
							<xsl:apply-templates
								select="PayEndYearFlag" />
						</PaymentDurationMode>
						<PaymentDuration>
							<xsl:value-of select="PayEndYear" />
						</PaymentDuration>
					</xsl:otherwise>
				</xsl:choose>

				<!-- 保险期间 需要特殊转换-->
				<xsl:choose>
					<xsl:when
						test="InsuYearFlag = 'A' and InsuYear=106">
						<DurationMode>Y</DurationMode>
						<Duration>100</Duration>
					</xsl:when><!-- 保终身-->
					<xsl:otherwise>
						<DurationMode>
							<xsl:call-template
								name="tran_InsuYearFlag">
								<xsl:with-param name="InsuYearFlag">
									<xsl:value-of select="InsuYearFlag" />
								</xsl:with-param>
							</xsl:call-template>
						</DurationMode>
						<Duration>
							<xsl:value-of select="InsuYear" />
						</Duration>
					</xsl:otherwise>
				</xsl:choose>
				<!--  领取年期/年龄类型  -->
				<PayoutDurationMode></PayoutDurationMode>
				<!--  领取年期/年龄（数字类型，不能为空）  -->
				<PayoutDuration>0</PayoutDuration>
				<!--  领取起始年龄（数字类型，不能为空） -->
				<PayoutStart>0</PayoutStart>
				<!--  领取终止年龄（数字类型，不能为空） -->
				<PayoutEnd>0</PayoutEnd>

				<!-- 现金价值表（没有的话整个节点不返回） -->
				<xsl:if test="count(CashValues/CashValue) > 0">
					<CashValues>
						<xsl:for-each select="CashValues/CashValue">
							<CashValue>
								<!-- 年末（数字类型，不能为空） -->
								<End>
									<xsl:value-of select="EndYear" />
								</End>
								<!-- 年末现金价值（数字类型，不能为空） -->
								<Cash>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(Cash)" />
								</Cash>
							</CashValue>
						</xsl:for-each>
					</CashValues>
				</xsl:if>

				<!-- 红利保额保单年度末现金价值表（没有的话整个节点不返回） -->
				<xsl:if test="count(BonusValues/BonusValue) > 0">
					<BonusValues>
						<xsl:for-each select="BonusValues/BonusValue">
							<BonusValue>
								<!-- 年末（数字类型，不能为空） -->
								<End>
									<xsl:value-of select="EndYear" />
								</End>
								<!-- 年末现金价值（数字类型，不能为空） -->
								<Cash>
									<xsl:value-of
										select="java:com.sinosoft.midplat.common.NumberUtil.fenToYuan(EndYearCash)" />
								</Cash>
							</BonusValue>
						</xsl:for-each>
					</BonusValues>
				</xsl:if>
			</OLifeExtension>
		</Coverage>
	</xsl:template>

	<!-- 证件类型【注意：“护照  ”空格排版用的，不能去掉】 -->
	<xsl:template match="IDType">
		<xsl:choose>
			<xsl:when test=".=0">身份证    </xsl:when>
			<xsl:when test=".=1">护照      </xsl:when>
			<xsl:when test=".=2">军官证    </xsl:when>
			<xsl:when test=".=3">驾照      </xsl:when>
			<xsl:when test=".=4">出生证明  </xsl:when>
			<xsl:when test=".=5">户口簿    </xsl:when>
			<xsl:when test=".=8">其他      </xsl:when>
			<xsl:when test=".=9">异常身份证</xsl:when>
		<!-- PBKINSR-506 招行银保通、网银新增证件类型 -->
			<xsl:when test=".=6">港澳回乡证</xsl:when>
			<xsl:when test=".=7">台胞证    </xsl:when>
		<!-- PBKINSR-506 招行银保通、网银新增证件类型 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 返回缴费方式 -->
	<xsl:template name="tran_PayIntv">
		<xsl:param name="PayIntv"></xsl:param>
		<xsl:choose>
			<xsl:when test="$PayIntv='12'">12</xsl:when><!-- 年缴 -->
			<xsl:when test="$PayIntv='1'">1</xsl:when><!-- 月缴 -->
			<xsl:when test="$PayIntv='0'">0</xsl:when><!-- 趸缴 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 缴费年期/年龄类型 -->
	<xsl:template name="tran_payendyearflag" match="PayEndYearFlag">
		<xsl:choose>
			<xsl:when test=".='A'">A</xsl:when><!-- 缴至某确定年龄 -->
			<xsl:when test=".='Y'">Y</xsl:when><!-- 年 -->
			<xsl:when test=".='M'">M</xsl:when><!-- 月 -->
			<xsl:when test=".='D'">D</xsl:when><!-- 日 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 保险年龄年期标志 -->
	<xsl:template name="tran_InsuYearFlag">
		<xsl:param name="InsuYearFlag"></xsl:param>
		<xsl:choose>
			<xsl:when test="$InsuYearFlag='A'">A</xsl:when><!-- 保至某确定年龄 -->
			<xsl:when test="$InsuYearFlag='Y'">Y</xsl:when><!-- 年保 -->
			<xsl:when test="$InsuYearFlag='M'">M</xsl:when><!-- 月保 -->
			<xsl:when test="$InsuYearFlag='D'">D</xsl:when><!-- 日保 -->
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="InsuYearFlag">
		<xsl:choose>
			<xsl:when test=".= 'Y'">年</xsl:when>
			<xsl:when test=".= 'A'">岁</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="InsuYearFlag" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 险种代码 -->
	<xsl:template match="RiskCode" >
		<xsl:choose>
			<xsl:when test=".='122009'">122009</xsl:when><!-- 安邦黄金鼎5号两全保险（分红型）A款  -->
			<!-- PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级 -->
			<xsl:when test=".='L12100'">122010</xsl:when><!-- 安邦盛世3号终身寿险（万能型） -->
			<xsl:when test=".='L12079'">122012</xsl:when><!-- 安邦盛世2号终身寿险（万能型）  -->
			<xsl:when test=".='L12073'">122029</xsl:when><!-- 安邦盛世5号终身寿险（万能型）  -->
			<xsl:when test=".='L12074'">122035</xsl:when><!-- 安邦盛世9号两全保险（万能型） -->
			<!-- PBKINSR-688 招行盛2（柜面、网银）、盛3（柜面、网银）、盛9（柜面、网银）、盛5（柜面）、50002（柜面）产品升级 -->
			<xsl:when test=".='122028'">122028</xsl:when><!-- 安邦附加安心7号重大疾病保险 -->
			<xsl:when test=".='122041'">122041</xsl:when><!-- 安邦附加盛世安康住院医疗保险A款 -->
			<xsl:when test=".='122042'">122042</xsl:when><!-- 安邦附加盛世安康住院医疗保险B款 -->
			<xsl:when test=".='122043'">122043</xsl:when><!-- 安邦附加盛世安康护理保险 -->
			<xsl:when test=".='122044'">122044</xsl:when><!-- 安邦附加盛世安康防癌疾病保险 -->
			<xsl:when test=".='122046'">50002</xsl:when><!-- 安邦长寿稳赢1号两全保险-->
			<!-- 安邦长寿智赢1号两全保险计划,2014-08-29停售 -->
			<xsl:when test=".='50006'">50006</xsl:when>
			<xsl:when test=".='L12052'">L12052</xsl:when>	<!-- 安邦长寿智赢1号年金保险 -->
			<!-- add 20151229 PBKINSR-1010 招行新产品盛世1号需求  begin -->
			<xsl:when test=".='L12080'">L12080</xsl:when><!-- 安邦盛世1号终身寿险（万能型）  -->
			<!-- add 20151229 PBKINSR-1010 招行新产品盛世1号需求  end -->
			<!-- add 20150222 PBKINSR-1071 招行新产品盛世1号B款需求  begin -->
			<xsl:when test=".='L12089'">L12089</xsl:when><!-- 安邦盛世1号终身寿险（万能型）B款  -->
			<!-- add 20150222 PBKINSR-1071 招行新产品盛世1号B款需求  end -->
			<!-- PBKINSR-1444 招行柜面东风3号 L12086  zx add 20160805 -->
			<xsl:when test=".='L12086'">L12086</xsl:when>
			<!-- PBKINSR-1530 招行柜面东风9号 L12088 zx add 20160805 -->
			<xsl:when test=".='L12088'">L12088</xsl:when>
			
			<xsl:otherwise>--</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
