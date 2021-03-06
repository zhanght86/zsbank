<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:java="http://xml.apache.org/xslt/java"
    exclude-result-prefixes="java">

    <xsl:template match="TranData">
        <TranData>
            <xsl:apply-templates select="Head" />
            <Body>
                <xsl:apply-templates select="Body" />
            </Body>
        </TranData>
    </xsl:template>

    <!-- 报文头信息 -->
    <xsl:template name="Head" match="Head">
        <Head>
            <!-- 交易日期[yyyyMMdd] -->
            <TranDate>
                <xsl:value-of select="TranDate" />
            </TranDate>
            <!-- 交易时间[hhmmss] -->
            <TranTime>
                <xsl:value-of select="TranTime" />
            </TranTime>
            <!-- 柜员代码 -->
            <TellerNo>
                <xsl:value-of select="TellerNo" />
            </TellerNo>
            <!-- 交易流水号 -->
            <TranNo>
                <xsl:value-of select="TranNo" />
            </TranNo>
            <!-- 银行网点 哈行没有地区码 -->
            <NodeNo>
                <xsl:value-of select="ZoneNo" /><xsl:value-of select="NodeNo" />
            </NodeNo>
            <xsl:copy-of select="FuncFlag" />
            <xsl:copy-of select="ClientIp" />
            <xsl:copy-of select="TranCom" />
            <BankCode>
                <xsl:value-of select="TranCom/@outcode" />
            </BankCode>
        </Head>
    </xsl:template>

    <!-- 报文体信息 -->
    <xsl:template name="Body" match="Body">
        <xsl:variable name="MainRisk"
            select="Risk[RiskCode=MainRiskCode]" />
        <!-- 投保单(印刷)号 -->
        <ProposalPrtNo>
            <xsl:value-of select="ProposalPrtNo" />
        </ProposalPrtNo>
        <!-- 保单合同印刷号 -->
        <ContPrtNo>
            <xsl:value-of select="ContPrtNo" />
        </ContPrtNo>
        <!-- 投保日期[yyyyMMdd] -->
        <PolApplyDate>
            <xsl:value-of select="PolApplyDate" />
        </PolApplyDate>
        <!-- 账户姓名 -->
        <AccName>
            <xsl:value-of select="AccName" />
        </AccName>
        <!-- 银行账户 -->
        <AccNo>
            <xsl:value-of select="AccNo" />
        </AccNo>
        <!-- 保单递送方式:1=邮寄，2=银行柜面领取 -->
        <GetPolMode>
        	<xsl:value-of select="GetPolMode" />
        </GetPolMode>
        <!-- 职业告知(N/Y) -->
        <JobNotice>
            <xsl:value-of select="JobNotice" />
        </JobNotice>
        <!-- 健康告知(N/Y)  -->
        <HealthNotice>
            <xsl:value-of select="HealthNotice" />
        </HealthNotice>
        <!--未成年被保险人是否在其他保险公司投保身故保险 Y是/N否-->
        <PolicyIndicator>
            <xsl:choose>
                <xsl:when test="InsuredTotalFaceAmount > 0">Y</xsl:when>
                <xsl:otherwise>N</xsl:otherwise>
            </xsl:choose>
        </PolicyIndicator>
        <!-- 保单递送类型1、纸制保单2、电子保单 -->
		<PolicyDeliveryMethod>1</PolicyDeliveryMethod>
        <!--累计投保身故保额(核心单位百元)-->
        <InsuredTotalFaceAmount><xsl:value-of select="InsuredTotalFaceAmount" /></InsuredTotalFaceAmount>
        <!--银行销售人员工号，保监会3号文增加该字段-->
        <ManagerNo><xsl:value-of select="ManagerNo" /></ManagerNo><!-- 网点分管代理保险业务负责人编号 -->
		<ManagerName><xsl:value-of select="ManagerName" /></ManagerName><!-- 网点分管代理保险业务负责人姓名 -->
        <SellerNo>
        	<xsl:value-of select="SellerNo" />
        </SellerNo>
        <!--出单网点名称-->
        <AgentComName>
            <xsl:value-of select="AgentComName" />
        </AgentComName>
        <!-- 网点许可证-->
        <AgentComCertiCode>
            <xsl:value-of select="AgentComCertiCode" />
        </AgentComCertiCode>
        <!--银行销售人员名称-->
        <TellerName>
            <xsl:value-of select="TellerName" />
        </TellerName>
        <!-- 销售人员资格证-->
        <TellerCertiCode>
            <xsl:value-of select="TellerCertiCode" />
        </TellerCertiCode>
        <!-- 销售人员电子邮箱-->
        <TellerEmail>
            <xsl:value-of select="TellerEmail" />
        </TellerEmail>
        <!-- 产品组合 -->
        <ContPlan>
            <!-- 产品组合编码 -->
            <ContPlanCode>
                <xsl:call-template name="tran_ContPlanCode">
                    <xsl:with-param name="contPlanCode">
                        <xsl:value-of select="$MainRisk/RiskCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </ContPlanCode>
            <!-- 产品组合份数 -->
            <ContPlanMult>
                <xsl:value-of select="$MainRisk/Mult" />
            </ContPlanMult>
        </ContPlan>
        <!-- 投保人 -->
        <Appnt>
            <xsl:apply-templates select="Appnt" />
        </Appnt>
        <!-- 被保人 -->
        <Insured>
            <xsl:apply-templates select="Insured" />
        </Insured>
        <!-- 受益人 -->
        <xsl:apply-templates select="Bnf" />

        <!-- 险种信息 -->
        <xsl:apply-templates select="Risk" />
    </xsl:template>
    
    <!-- 投保人信息 -->
    <xsl:template name="Appnt" match="Appnt">
        <!-- 姓名 -->
        <Name>
            <xsl:value-of select="Name" />
        </Name>
        <!-- 性别 -->
        <Sex>
            <xsl:value-of select="Sex" />
        </Sex>
        <!-- 出生日期(yyyyMMdd) -->
        <Birthday>
            <xsl:value-of select="Birthday" />
        </Birthday>
        <!-- 证件类型 -->
        <IDType>
            <xsl:value-of select="IDType" />
        </IDType>
        <!-- 证件号码 -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- 证件有效起期（yyyymmdd） -->
        <IDTypeStartDate>
            <xsl:value-of select="IDTypeStartDate" />
        </IDTypeStartDate>
        <!-- 证件有效止期（yyyymmdd） -->
        <IDTypeEndDate>
            <xsl:value-of select="IDTypeEndDate" />
        </IDTypeEndDate>
        <!-- 职业代码 -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- 国籍 -->
        <Nationality>
            <xsl:value-of select="Nationality" />
        </Nationality>
        <!-- 身高(cm)-->
        <Stature>
            <xsl:value-of select="Stature" />
        </Stature>
        <!-- 体重(g)  -->
        <Weight>
            <xsl:value-of select="Weight" />
        </Weight>
        <!-- 投保人年收入(分) -->
		<xsl:choose>
			<xsl:when test="Salary=''">
				<Salary />
			</xsl:when>
			<xsl:otherwise>
				<Salary>
					<xsl:value-of
						select="Salary" />
				</Salary>
			</xsl:otherwise>
		</xsl:choose>
		<!-- 投保人家庭年收入(分) -->
		<xsl:choose>
			<xsl:when test="FamilySalary=''">
				<FamilySalary />
			</xsl:when>
			<xsl:otherwise>
				<FamilySalary>
					<xsl:value-of
						select="FamilySalary" />
				</FamilySalary>
			</xsl:otherwise>
		</xsl:choose>
        <!-- 1.城镇，2.农村 --><!-- 与银行测试时需要注意银行给值问题 -->
        <LiveZone>
            <xsl:value-of select="LiveZone" />
        </LiveZone>
        <!-- 是否已进行风险评估问卷调查 -->
        <RiskAssess>
            <xsl:value-of select="RiskAssess" />
        </RiskAssess>
        <!-- 投保人主要收入来源 -->
        <SalarySource>
            <xsl:value-of select="SalarySource" />
        </SalarySource>
        <!-- 投保人家庭年收入主要来源 -->
        <FamilySalarySource>
            <xsl:value-of select="FamilySalarySource" />
        </FamilySalarySource>
        <!-- 投保人保费预算 -->
        <PremBudget>
            <xsl:value-of select="PremBudget" />
        </PremBudget>
        <!-- 婚姻状况（银行无法增加录入项信息，非必填） -->
        <MaritalStatus>
            <xsl:value-of select="MaritalStatus" />
        </MaritalStatus>
        <!-- 地址 -->
        <Address>
            <xsl:value-of select="Address" />
        </Address>
        <!-- 邮编 -->
        <ZipCode>
            <xsl:value-of select="ZipCode" />
        </ZipCode>
        <!-- 手机 -->
        <Mobile>
            <xsl:value-of select="Mobile" />
        </Mobile>
        <!-- 座机 -->
        <Phone>
            <xsl:value-of select="Phone" />
        </Phone>
        <!-- 邮箱 -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
        <!-- 投保人与被保人关系 -->
        <RelaToInsured>
            <xsl:value-of select="RelaToInsured" />
        </RelaToInsured>
    </xsl:template>


    <!-- 被保险人信息 -->
    <xsl:template name="Insured" match="Insured">
        <!-- 姓名 -->
        <Name>
            <xsl:value-of select="Name" />
        </Name>
        <!-- 性别 -->
        <Sex>
            <xsl:value-of select="Sex" />
        </Sex>
        <!-- 出生日期(yyyyMMdd) -->
        <Birthday>
            <xsl:value-of select="Birthday" />
        </Birthday>
        <!-- 证件类型 -->
        <IDType>
            <xsl:value-of select="IDType" />
        </IDType>
        <!-- 证件号码 -->
        <IDNo>
            <xsl:value-of select="IDNo" />
        </IDNo>
        <!-- 证件有效起期（yyyymmdd） -->
        <IDTypeStartDate>
            <xsl:value-of select="IDTypeStartDate" />
        </IDTypeStartDate>
        <!-- 证件有效止期（yyyymmdd） -->
        <IDTypeEndDate>
            <xsl:value-of select="IDTypeEndDate" />
        </IDTypeEndDate>
        <!-- 职业代码 -->
        <JobCode>
            <xsl:value-of select="JobCode" />
        </JobCode>
        <!-- 国籍 -->
        <Nationality>
            <xsl:value-of select="Nationality" />
        </Nationality>
        <!-- 身高（cm） -->
        <Stature>
            <xsl:value-of select="Stature" />
        </Stature>
        <!-- 体重（kg） -->
        <Weight>
            <xsl:value-of select="Weight" />
        </Weight>
        <!-- 婚否 -->
        <MaritalStatus>
            <xsl:value-of select="MaritalStatus" />
        </MaritalStatus>
        <!-- 地址 -->
        <Address>
            <xsl:value-of select="Address" />
        </Address>
        <!-- 邮编 -->
        <ZipCode>
            <xsl:value-of select="ZipCode" />
        </ZipCode>
        <!-- 手机 -->
        <Mobile>
            <xsl:value-of select="Mobile" />
        </Mobile>
        <!-- 座机 -->
        <Phone>
            <xsl:value-of select="Phone" />
        </Phone>
        <!-- 邮箱 -->
        <Email>
            <xsl:value-of select="Email" />
        </Email>
    </xsl:template>

    <!-- 受益人信息 -->
    <xsl:template match="Bnf">
        <Bnf>
            <Type>1</Type>
            <!-- 受益顺序 (整数，从1开始) -->
            <Grade>
                <xsl:value-of select="Grade" />
            </Grade>
            <!-- 姓名 -->
            <Name>
                <xsl:value-of select="Name" />
            </Name>
            <!-- 性别 -->
            <Sex>
                <xsl:value-of select="Sex" />
            </Sex>
            <!-- 出生日期(yyyyMMdd) -->
            <Birthday>
                <xsl:value-of select="Birthday" />
            </Birthday>
            <!-- 证件类型 -->
            <IDType>
                <xsl:value-of select="IDType" />
            </IDType>
            <!-- 证件号码 -->
            <IDNo>
                <xsl:value-of select="IDNo" />
            </IDNo>
            <!-- 证件有效起期（yyyymmdd） -->
            <IDTypeStartDate>
                <xsl:value-of select="IDTypeStartDate" />
            </IDTypeStartDate>
            <!-- 证件有效止期（yyyymmdd） -->
            <IDTypeEndDate>
                <xsl:value-of select="IDTypeEndDate" />
            </IDTypeEndDate>
            <!-- 受益人与被保险人关系 -->
            <RelaToInsured>
                <xsl:value-of select="RelaToInsured" />
            </RelaToInsured>
            <!-- 国籍--><!--保监会3号文邮储增加该字段-->
            <Nationality>
            	<xsl:value-of select="Nationality" />
            </Nationality> 
            <!-- 收益比例（整数） -->
            <Lot>
                <xsl:value-of select="Lot" />
            </Lot>
        </Bnf>
    </xsl:template>

    <!-- 险种信息 -->
    <xsl:template match="Risk">
        <Risk>
            <!-- 险种代码 -->
            <RiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="riskCode">
                        <xsl:value-of select="RiskCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </RiskCode>
            <!-- 主险险种代码 -->
            <MainRiskCode>
                <xsl:call-template name="tran_RiskCode">
                    <xsl:with-param name="riskCode">
                        <xsl:value-of select="MainRiskCode" />
                    </xsl:with-param>
                </xsl:call-template>
            </MainRiskCode>
            <!-- 保额(单位为分) ，暂时为空-->
            <Amnt>
                <xsl:value-of select="Amnt" />
            </Amnt>
            <!-- 保险费(单位为分)，按保费卖 -->
            <Prem>
                <xsl:value-of select="Prem" />
            </Prem>
            <!-- 投保份数，暂时为空- -->
            <Mult>
                <xsl:value-of select="Mult" />
            </Mult>
            <!-- 缴费形式 -->
            <PayMode></PayMode>
            <!-- 缴费频次 -->
            <PayIntv>
                <xsl:value-of select="PayIntv" />
            </PayIntv>
            <!-- 保险年期年龄标志 -->
            <InsuYearFlag>
                <xsl:value-of select="InsuYearFlag" />
            </InsuYearFlag>
            <!-- 保险年期年龄 保终身写死106-->
            <InsuYear>
                <xsl:value-of select="InsuYear" />
            </InsuYear>
            <!-- 缴费年期年龄标志 -->
            <PayEndYearFlag>
                <xsl:value-of select="PayEndYearFlag" />
            </PayEndYearFlag>
            <!-- 缴费年期年龄 趸交写死1000-->
            <PayEndYear>
                <xsl:value-of select="PayEndYear" />
            </PayEndYear>
            <!-- 红利领取方式 -->
            <BonusGetMode>
                <xsl:value-of select="BonusGetMode" />
            </BonusGetMode>
            <FullBonusGetMode><xsl:value-of select="FullBonusGetMode" /></FullBonusGetMode><!-- 满期领取金领取方式 -->
            <GetYearFlag><xsl:value-of select="GetYearFlag" /></GetYearFlag>
			<!-- 领取年龄年期标志 -->
			<GetYear><xsl:value-of select="GetYear" /></GetYear>
			<!-- 领取年龄 -->
			<GetIntv><xsl:value-of select="GetIntv" /></GetIntv>
			<!-- 领取方式 -->
			<GetBankCode><xsl:value-of select="GetBankCode" /></GetBankCode>
			<!-- 领取银行编码 -->
			<GetBankAccNo><xsl:value-of select="GetBankAccNo" /></GetBankAccNo>
			<!-- 领取银行账户 -->
			<GetAccName><xsl:value-of select="GetAccName" /></GetAccName>
			<!-- 领取银行户名 -->
			<AutoPayFlag><xsl:value-of select="AutoPayFlag" /></AutoPayFlag>
			<!-- 自动垫交标志 -->
        </Risk>
    </xsl:template>

    <!-- 产品组合代码 -->
    <xsl:template name="tran_ContPlanCode">
        <xsl:param name="contPlanCode" />
        <xsl:choose>            
            <xsl:when test="$contPlanCode='50015'">50015</xsl:when><!-- 安邦长寿稳赢保险计划 -->
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 险种代码 -->
    <xsl:template name="tran_RiskCode">
        <xsl:param name="riskCode" />
        <xsl:choose>        	
            <xsl:when test="$riskCode='50015'">50015</xsl:when><!-- 安邦长寿稳赢保险计划 -->
            <xsl:otherwise>--</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
