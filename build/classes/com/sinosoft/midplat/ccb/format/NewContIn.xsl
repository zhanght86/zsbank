<?xml version="1.0" encoding="GBK"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<xsl:template match="/">
<TranData>
	<xsl:apply-templates select="Transaction/Transaction_Header"/>
	
	<Body>
		<xsl:apply-templates select="Transaction/Transaction_Body" />
	</Body>
</TranData>
</xsl:template>

<xsl:template name="Head" match="Transaction_Header">
<Head>
	<TranDate><xsl:value-of select="BkPlatDate"/></TranDate>
	<TranTime><xsl:value-of select="BkPlatTime"/></TranTime>
	<TellerNo><xsl:value-of select="BkTellerNo"/></TellerNo>
	<TranNo><xsl:value-of select="BkPlatSeqNo"/></TranNo>
	<NodeNo><xsl:value-of select="BkBrchNo"/></NodeNo>
	<xsl:copy-of select="../Head/*"/>
	<BankCode><xsl:value-of select="../Head/TranCom/@outcode"/></BankCode>
</Head>
</xsl:template>

<xsl:template name="Body" match="Transaction_Body">
<ProposalPrtNo><xsl:value-of select="PbApplNo" /></ProposalPrtNo>
<ContPrtNo><xsl:value-of select="BkVchNo" /></ContPrtNo>
<PolApplyDate><xsl:value-of select="../Transaction_Header/BkPlatDate" /></PolApplyDate>	<!-- ���в���Ͷ�����ڣ�ȡ�������� -->

<!--������������-->
<AgentComName><xsl:value-of select="../Transaction_Header/BkBrchName"/></AgentComName>
<!--����������Ա����-->
<SellerNo><xsl:value-of select="BkRckrNo"/></SellerNo>
<!--����������Ա����-->
<TellerName><xsl:value-of select="BkSaleName"/></TellerName>
<!--����������Ա�ʸ�֤-->
<TellerCertiCode><xsl:value-of select="BkSaleCertNo"/></TellerCertiCode>

<AccName><xsl:value-of select="PbHoldName" /></AccName>	<!-- ȡͶ�������� -->
<AccNo><xsl:value-of select="BkAcctNo1" /></AccNo>
<GetPolMode>2</GetPolMode> <!-- �������ͷ�ʽ -->
<JobNotice></JobNotice> <!-- ְҵ��֪(N/Y) -->
<HealthNotice>
	<xsl:call-template name="tran_healthnotice">
		<xsl:with-param name="healthnotice" select="LiHealthTag" />
	</xsl:call-template>
</HealthNotice> <!-- ������֪(N/Y) -->
<xsl:choose>
	<xsl:when test="PiZxbe20>0">
		<PolicyIndicator>Y</PolicyIndicator>
	</xsl:when>
	<xsl:otherwise>	<!-- ���� -->
		<PolicyIndicator>N</PolicyIndicator>
	</xsl:otherwise>
</xsl:choose>
<!--δ���걻�������Ƿ����������չ�˾Ͷ�����ʱ��� Y��N�� -->
<InsuredTotalFaceAmount><xsl:value-of select="PiZxbe20*0.01" /></InsuredTotalFaceAmount>
<!--�ۼ�δ������Ͷ�����ʱ��� �������ֶαȽ����⣬��λ�ǰ�Ԫ-->

<!-- ��ϲ�Ʒ���� -->
<xsl:variable name="ContPlanMult">
	<xsl:choose>
		<xsl:when test="PbSlipNumb=''">
			<xsl:value-of select="PbSlipNumb" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="format-number(PbSlipNumb,'#')" />
		</xsl:otherwise>
	</xsl:choose>	
</xsl:variable>

<!-- ���� -->
<xsl:variable name="MainRiskCode">
	<xsl:call-template name="tran_riskcode">
		<xsl:with-param name="riskcode" select="PbInsuType" />
	</xsl:call-template>
</xsl:variable>

<!-- ��ϲ�Ʒ���� -->
<xsl:variable name="tContPlanCode">
	<xsl:call-template name="tran_ContPlanCode">
		<xsl:with-param name="contPlanCode" select="PbInsuType" />
	</xsl:call-template>
</xsl:variable>

<!-- ��Ʒ��� -->
<ContPlan>
	<!-- ��Ʒ��ϱ��� -->
	<ContPlanCode><xsl:value-of select="$tContPlanCode" /></ContPlanCode>
	<!-- ��Ʒ��Ϸ��� -->
	<ContPlanMult><xsl:value-of select="$ContPlanMult" /></ContPlanMult>
</ContPlan>

<xsl:call-template name="Appnt" />
<xsl:call-template name="Insured" />
<xsl:apply-templates select="Benf_List/Benf_Detail" />


<xsl:variable name="PayIntv"><xsl:apply-templates select="PbPayPeriod" /></xsl:variable>
<xsl:variable name="InsuYearFlag"><xsl:apply-templates select="PbInsuYearFlag" /></xsl:variable>
<xsl:variable name="PayEndYearFlag">Y</xsl:variable>	<!-- ���в�����־��Ŀǰ������ɴ����������ܴ˴������  -->
<xsl:variable name="BonusGetMode"><xsl:apply-templates select="LiBonusGetMode" /></xsl:variable>
<xsl:variable name="PbInsuYearFlag" select="PbInsuYearFlag"></xsl:variable>

<Risk>	<!-- ���� -->
	<RiskCode><xsl:value-of select="$MainRiskCode" /></RiskCode>
	<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
	<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbInsuAmt)" /></Amnt>
	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbInsuExp)" /></Prem>
	<Mult><xsl:value-of select="format-number(PbSlipNumb, '#')" /></Mult>
    <PayMode></PayMode>
	<PayIntv><xsl:value-of select="$PayIntv" /></PayIntv>
	<InsuYearFlag><xsl:value-of select="$InsuYearFlag" /></InsuYearFlag>
	<InsuYear><xsl:if test="$PbInsuYearFlag=1">106</xsl:if>
	<xsl:if test="$PbInsuYearFlag!=1"><xsl:value-of select="LiInsuPeriod" /></xsl:if>
	</InsuYear>
	<PayEndYearFlag><xsl:value-of select="$PayEndYearFlag" /></PayEndYearFlag>
	<xsl:choose>
		<xsl:when test="$PayIntv=0">	<!-- ���� -->
			<PayEndYear>1000</PayEndYear>
		</xsl:when>
		<xsl:otherwise>	<!-- ���� -->
			<PayEndYear><xsl:value-of select="PbPayAgeTag" /></PayEndYear>
		</xsl:otherwise>
	</xsl:choose>
	<BonusGetMode><xsl:value-of select="$BonusGetMode" /></BonusGetMode>
</Risk>
<xsl:for-each select="Appd_List/Appd_Detail">	<!-- ������ -->
<Risk>
	<RiskCode>
		<xsl:call-template name="tran_riskcode">
			<xsl:with-param name="riskcode" select="LiAppdInsuType" />
		</xsl:call-template>
	</RiskCode>
	<MainRiskCode><xsl:value-of select="$MainRiskCode" /></MainRiskCode>
	<Amnt><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(LiAppdInsuAmot)" /></Amnt>
	<Prem><xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(LiAppdInsuExp)" /></Prem>
	<Mult><xsl:value-of select="format-number(LiAppdInsuNumb, '#')" /></Mult>
    <PayMode></PayMode>
	<PayIntv><xsl:value-of select="$PayIntv" /></PayIntv>
	<InsuYearFlag><xsl:value-of select="$InsuYearFlag" /></InsuYearFlag>
	<InsuYear>
	<xsl:if test="$PbInsuYearFlag=1">106</xsl:if>
	<xsl:if test="$PbInsuYearFlag!=1"><xsl:value-of select="LiAppdInsuTerm" /></xsl:if>
	</InsuYear>
	<PayEndYearFlag><xsl:value-of select="$PayEndYearFlag" /></PayEndYearFlag>
	<xsl:choose>
		<xsl:when test="$PayIntv=0">	<!-- ���� -->
			<PayEndYear>1000</PayEndYear>
		</xsl:when>
		<xsl:otherwise>	<!-- ���� -->
			<PayEndYear><xsl:value-of select="LiAppdInsuPayTerm" /></PayEndYear>
		</xsl:otherwise>
	</xsl:choose>
	<BonusGetMode><xsl:value-of select="$BonusGetMode" /></BonusGetMode>
</Risk>
</xsl:for-each>
</xsl:template>

<!-- Ͷ���� -->
<xsl:template name="Appnt">
<Appnt>
	<Name><xsl:value-of select="PbHoldName" /></Name>
	<Sex>
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex" select="PbHoldSex" />
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="PbHoldBirdy" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype" select="PbHoldIdType" />
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="PbHoldId" /></IDNo>
	<IDTypeStartDate><xsl:value-of select="PbIdStartDate" /></IDTypeStartDate > <!-- ֤����Ч���� -->
	<IDTypeEndDate><xsl:value-of select="PbIdEndDate" /></IDTypeEndDate > <!-- ֤����Чֹ�� -->
	<xsl:variable name="JobCode">
		<xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode" select="PbHoldOccupCode" />
		</xsl:call-template>
	</xsl:variable>		
	<JobCode>
		<xsl:choose>
			<xsl:when test="$JobCode='--'">4030111</xsl:when>
			<xsl:otherwise><xsl:value-of select="$JobCode" /></xsl:otherwise>
		</xsl:choose>
	</JobCode>
	<!-- Ͷ���������� -->
	<Salary>
		<xsl:choose>
			<xsl:when test="PbInCome=''">
				<xsl:value-of select="PbInCome" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbInCome)"/>
			</xsl:otherwise>
		</xsl:choose>
	</Salary>
	<!-- Ͷ���˼�ͥ������ -->
	<FamilySalary>
		<xsl:choose>
			<xsl:when test="PbHomeInCome=''">
				<xsl:value-of select="PbHomeInCome" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="java:com.sinosoft.midplat.common.NumberUtil.yuanToFen(PbHomeInCome)"/>
			</xsl:otherwise>
		</xsl:choose>
	</FamilySalary>
	<!-- 1.����2.ũ�� -->
	<LiveZone><xsl:value-of select="PbDenType"/></LiveZone>
	
	<Nationality>
		<xsl:call-template name="tran_Nationality">
		  <xsl:with-param name="nationality">
		 	<xsl:value-of select="PbNationality"/>
	      </xsl:with-param>
	    </xsl:call-template>
	</Nationality> <!-- ���� -->
	<Address><xsl:value-of select="PbHoldHomeAddr" /></Address>
	<ZipCode><xsl:value-of select="PbHoldHomePost" /></ZipCode>
	<Mobile><xsl:value-of select="PbHoldMobl" /></Mobile>
	<Phone><xsl:value-of select="PbHoldHomeTele" /></Phone>
	<Email><xsl:value-of select="PbHoldEmail" /></Email>
	<RelaToInsured>
		<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation" select="PbHoldRcgnRela" />
		</xsl:call-template>
	</RelaToInsured>
</Appnt>
</xsl:template>

<!-- ������ -->
<xsl:template name="Insured">
<Insured>
	<Name><xsl:value-of select="LiRcgnName" /></Name>
	<Sex>
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex" select="LiRcgnSex" />
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="LiRcgnBirdy" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype" select="LiRcgnIdType" />
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="LiRcgnId" /></IDNo>
	<IDTypeStartDate><xsl:value-of select="LiIdStartDate" /></IDTypeStartDate > <!-- ֤����Ч���� -->
	<IDTypeEndDate><xsl:value-of select="LiIdEndDate" /></IDTypeEndDate > <!-- ֤����Чֹ�� -->
	<JobCode>
		<xsl:call-template name="tran_jobcode">
			<xsl:with-param name="jobcode" select="LiRcgnOccupCode" />
		</xsl:call-template>
	</JobCode>
	<Nationality>
		<xsl:call-template name="tran_Nationality">
		  <xsl:with-param name="nationality">
		 	<xsl:value-of select="LiNationality"/>
	      </xsl:with-param>
	    </xsl:call-template>
	</Nationality> <!-- ���� -->
	<Address><xsl:value-of select="LiRcgnAddr" /></Address>
	<ZipCode><xsl:value-of select="LiRcgnPost" /></ZipCode>
	<Mobile><xsl:value-of select="LiRcgnMobl" /></Mobile>
	<Phone><xsl:value-of select="LiRcgnTele" /></Phone>
	<Email><xsl:value-of select="LiRcgnEmail" /></Email>
</Insured>
</xsl:template>

<!-- ������ -->
<xsl:template name="Bnf" match="Benf_Detail">
<Bnf>
	<Type>1</Type>	<!-- Ĭ��Ϊ��1-���������ˡ� -->
	<Grade><xsl:value-of select="PbBenfSequ" /></Grade>
	<Name><xsl:value-of select="PbBenfName" /></Name>
	<Sex>
		<xsl:call-template name="tran_sex">
			<xsl:with-param name="sex" select="PbBenfSex" />
		</xsl:call-template>
	</Sex>
	<Birthday><xsl:value-of select="PbBenfBirdy" /></Birthday>
	<IDType>
		<xsl:call-template name="tran_idtype">
			<xsl:with-param name="idtype" select="PbBenfIdType" />
		</xsl:call-template>
	</IDType>
	<IDNo><xsl:value-of select="PbBenfId" /></IDNo>
	<Lot><xsl:value-of select="PbBenfProp" /></Lot>
	<RelaToInsured>
		<xsl:call-template name="tran_relation">
			<xsl:with-param name="relation" select="PbBenfHoldRela" />
		</xsl:call-template>
    </RelaToInsured>
</Bnf>
</xsl:template>


<xsl:template name="MainRisk">

</xsl:template>

<!-- ������֪ -->
<xsl:template name="tran_HealthNotice" match="LiHealthTag">
<xsl:choose>
	<xsl:when test=".=1">Y</xsl:when>
	<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �Ա� -->
<xsl:template name="tran_sex">
<xsl:param name="sex" />
<xsl:choose>
	<xsl:when test="$sex=1">0</xsl:when>	<!-- �� -->
	<xsl:when test="$sex=2">1</xsl:when>	<!-- Ů -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ֤������ -->
<xsl:template name="tran_idtype">
<xsl:param name="idtype" />
<xsl:choose>
	<xsl:when test="$idtype='A'">0</xsl:when>	<!-- ����֤ -->
	<xsl:when test="$idtype='B'">2</xsl:when>	<!-- ����֤ -->
	<xsl:when test="$idtype='C'">2</xsl:when>	<!-- ��ž���ְ�ɲ�֤ -->
	<xsl:when test="$idtype='D'">2</xsl:when>	<!-- ����֤ -->
	<xsl:when test="$idtype='E'">2</xsl:when>	<!-- ��ž�ʿ��֤ -->
	<xsl:when test="$idtype='F'">5</xsl:when>	<!-- ���ڱ� -->
	<xsl:when test="$idtype='I'">1</xsl:when>	<!-- ������� ����-->
	<xsl:when test="$idtype='J'">1</xsl:when>	<!-- ���й��� ����-->
	<xsl:when test="$idtype='K'">2</xsl:when>	<!-- �侯��ְ�ɲ�֤ -->
	<xsl:when test="$idtype='L'">2</xsl:when>	<!-- �侯ʿ��֤ -->
	<xsl:when test="$idtype='M'">3</xsl:when>	<!-- ���� -->
	<xsl:otherwise>8</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ְҵ���� -->
<xsl:template name="tran_jobcode">
<xsl:param name="jobcode" />
<xsl:choose>
	<xsl:when test="$jobcode='A'">4030111</xsl:when>	<!-- ���һ��ء���Ⱥ��֯����ҵ����ҵ��λ��Ա -->
	<xsl:when test="$jobcode='B'">2050101</xsl:when>	<!-- ����רҵ������Ա -->
	<xsl:when test="$jobcode='C'">2070109</xsl:when>	<!-- ����ҵ����Ա -->
	<xsl:when test="$jobcode='D'">2080103</xsl:when>	<!-- ����רҵ��Ա -->
	<xsl:when test="$jobcode='E'">2090104</xsl:when>	<!-- ��ѧ��Ա -->
	<xsl:when test="$jobcode='F'">2100106</xsl:when>	<!-- ���ų��漰��ѧ����������Ա -->
	<xsl:when test="$jobcode='G'">2130101</xsl:when>	<!-- �ڽ�ְҵ�� -->
	<xsl:when test="$jobcode='H'">3030101</xsl:when>	<!-- �����͵���ҵ����Ա -->
	<xsl:when test="$jobcode='I'">4010101</xsl:when>	<!-- ��ҵ������ҵ��Ա -->
	<xsl:when test="$jobcode='J'">5010107</xsl:when>	<!-- ũ���֡������桢ˮ��ҵ������Ա -->
	<xsl:when test="$jobcode='K'">6240105</xsl:when>	<!-- ������Ա -->
	<xsl:when test="$jobcode='L'">2020103</xsl:when>	<!-- ��ַ��̽��Ա -->
	<xsl:when test="$jobcode='M'">2020906</xsl:when>	<!-- ����ʩ����Ա -->
	<xsl:when test="$jobcode='N'">6050611</xsl:when>	<!-- �ӹ����졢���鼰������Ա -->
	<xsl:when test="$jobcode='O'">7010103</xsl:when>	<!-- ���� -->
	<xsl:when test="$jobcode='P'">8010101</xsl:when>	<!-- ��ҵ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��ϵ -->
<xsl:template name="tran_relation">
<xsl:param name="relation" />
<xsl:choose>
	<xsl:when test="$relation=1">00</xsl:when>	<!-- ���� -->
	<xsl:when test="$relation=2">02</xsl:when>	<!-- ��ż -->
	<xsl:when test="$relation=3">02</xsl:when>	<!-- ��ż -->
	<xsl:when test="$relation=4">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test="$relation=5">01</xsl:when>	<!-- ��ĸ -->
	<xsl:when test="$relation=6">03</xsl:when>	<!-- ��Ů -->
	<xsl:when test="$relation=7">03</xsl:when>	<!-- ��Ů -->
	<xsl:when test="$relation=30">04</xsl:when>
	<xsl:otherwise>04</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ���ִ��� -->
<xsl:template name="tran_riskcode">
<xsl:param name="riskcode" />
<xsl:choose>
	<xsl:when test="$riskcode=2001">122001</xsl:when>	<!-- ����ƽ�1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=2002">122002</xsl:when>	<!-- ����ƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=2003">122003</xsl:when>	<!-- ����۱���1����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=2004">122004</xsl:when>	<!-- ����ӻƽ�2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=2005">122005</xsl:when>	<!-- ����ƽ�3����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=2006">122006</xsl:when>	<!-- ����۱���2����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=2008">122008</xsl:when>	<!-- ���������1���������գ������ͣ� -->
	<xsl:when test="$riskcode=2009">122009</xsl:when>	<!-- ����ƽ�5����ȫ���գ��ֺ��ͣ�A�� -->
	<xsl:when test="$riskcode=2010">122010</xsl:when>	<!-- ����ʢ��3���������գ������ͣ� -->
	<xsl:when test="$riskcode=2035">122035</xsl:when>	<!-- ����ʢ��9����ȫ���գ������ͣ� -->
	<!-- �������Ӯ1������ռƻ�,2014-08-29ͣ�� 
	<xsl:when test="$riskcode=2052">50006</xsl:when>
	-->	
	<xsl:when test="$riskcode=2052">L12052</xsl:when>	<!-- �������Ӯ1������� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ��ϲ�Ʒ����ת�� -->
<xsl:template name="tran_ContPlanCode">
	<xsl:param name="contPlanCode" />
</xsl:template>

<!-- �����ĽɷѼ��/Ƶ�� -->
<xsl:template name="tran_payintv" match="PbPayPeriod">
<xsl:choose>
	<xsl:when test=".=0">0</xsl:when>	  <!-- ���� -->
	<xsl:when test=".=12">12</xsl:when>	  <!-- �꽻 -->
	<xsl:when test=".=1">1</xsl:when>	  <!-- �½� -->
	<xsl:when test=".=6">6</xsl:when>	  <!-- ���꽻 -->
	<xsl:when test=".=3">3</xsl:when>	  <!-- ���� -->
	<xsl:when test=".=-1">-1</xsl:when>	  <!-- �����ڽ� -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- �������������־ -->
<xsl:template name="tran_insuyearflag" match="PbInsuYearFlag">
<xsl:choose>
	<xsl:when test=".=2">Y</xsl:when>	<!-- ���� -->
	<xsl:when test=".=4">M</xsl:when>	<!-- ���� -->
	<xsl:when test=".=5">D</xsl:when>	<!-- ���� -->
	<xsl:when test=".=1">A</xsl:when>   <!-- ���� -->
	<xsl:when test=".=6">A</xsl:when>   <!-- ��ĳһ���� -->
</xsl:choose>
</xsl:template>

<!-- ������ȡ��ʽ -->
<xsl:template name="tran_bonusgetmode" match="LiBonusGetMode">
<xsl:choose>
	<xsl:when test=".=0">2</xsl:when>	<!-- ֱ�Ӹ��� -->
	<xsl:when test=".=1">3</xsl:when>	<!-- �ֽ����� -->
	<xsl:when test=".=2">1</xsl:when>	<!-- �ۼ���Ϣ -->
	<xsl:when test=".=3">5</xsl:when>	<!-- �����  -->
	<xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- ����ת�� -->
<xsl:template name="tran_Nationality">
	<xsl:param name="nationality">0</xsl:param>
	<xsl:choose>		
		<xsl:when test="$nationality = '0156'">CHN</xsl:when> <!-- �й�  -->
		<xsl:when test="$nationality = '0826'">GB</xsl:when>  <!-- Ӣ��  -->
		<xsl:when test="$nationality = '0392'">JP</xsl:when>  <!-- �ձ�  -->
		<xsl:when test="$nationality = '0643'">RU</xsl:when>  <!-- ����˹  -->
		<xsl:when test="$nationality = '0840'">US</xsl:when>  <!-- ����  -->
		<xsl:otherwise>OTH</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ������֪  -->
<xsl:template name="tran_healthnotice">
<xsl:param name="healthnotice" />
<xsl:choose>
	<xsl:when test="$healthnotice=0">N</xsl:when>	<!-- �޽�����֪ -->
	<xsl:when test="$healthnotice=1">Y</xsl:when>	<!-- �н�����֪ -->
	<xsl:otherwise>--</xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>