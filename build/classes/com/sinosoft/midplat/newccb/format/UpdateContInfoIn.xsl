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
	
	<!-- 保单信息公共节点 -->
	<PubContInfo>
		<!-- 银行交易渠道(0-传统银保通、1-网银、8-自助终端)-->
		<SourceType>0</SourceType>
		<!-- 重送标志:0否，1是--><!--必填项-->
		<RepeatType></RepeatType>
		<!-- 保险单号码 --><!--必填项 -->
		<ContNo><xsl:value-of select="InsPolcy_No" /></ContNo>
		<!-- 保单印刷号码 -->
		<PrtNo></PrtNo>
		<!-- 保单密码 -->
		<ContNoPSW><xsl:value-of select="InsPolcy_Pswd" /></ContNoPSW>
		<!-- 保险产品代码 （主险）-->
		<RiskCode></RiskCode>
		<!-- 投保人证件类型 -->
		<AppntIDType>
			<xsl:call-template name="tran_IDType">
				<xsl:with-param name="idtype" select="Plchd_Crdt_TpCd" />
			</xsl:call-template>
		</AppntIDType>
		<!-- 投保人证件号码 -->
		<AppntIDNo><xsl:value-of select="Plchd_Crdt_No" /></AppntIDNo>
		 <!-- 投保人姓名 -->
		<AppntName><xsl:value-of select="Plchd_Nm" /></AppntName>
		<!-- 投保人证件有效截止日期 -->
		<AppntIdTypeEndDate></AppntIdTypeEndDate>
		<!-- 投保人住宅电话 (投保人联系电话) -->
 	 	<AppntPhone></AppntPhone>
		<!-- 被保人证件类型 -->
		 <InsuredIDType></InsuredIDType>
		<!-- 被保人证件号码 -->
		<InsuredIDNo></InsuredIDNo>
		 <!-- 被保人姓名 -->
		<InsuredName></InsuredName>
		<!-- 被保人证件有效截止日期 -->
		<InsuredIdTypeEndDate></InsuredIdTypeEndDate>
		<!-- 被保人住宅电话 (投保人联系电话) -->
		<InsuredPhone></InsuredPhone>
		<!-- 投保人关系代码 -->
		<RelationRoleCode1></RelationRoleCode1>
		<!-- 投保人关系 -->
		<RelationRoleName1></RelationRoleName1>
		<!-- 被保人关系代码 -->
		<RelationRoleCode2></RelationRoleCode2>
		<!-- 被保人关系 -->
		<RelationRoleName2></RelationRoleName2>
		<!-- 收付费方式(09-无卡支付) 默认为7=银行转账(制返盘)--><!-- 确认交易时为必填项 -->
		<PayMode>7</PayMode>
		<!-- 收付费银行编号--><!-- 确认交易时为必填项 -->
		<PayGetBankCode></PayGetBankCode>
		<!-- 收付费银行名称  省 市 银行--><!-- 确认交易时为必填项 -->
		<BankName></BankName>
		<!-- 补退费帐户帐号--><!-- 确认交易时为必填项 -->
		<BankAccNo></BankAccNo>
		<!-- 补退费帐户户名--><!-- 确认交易时为必填项 -->
		<BankAccName></BankAccName>
		<!--领款人证件类型 -->
		<BankAccIDType></BankAccIDType>
		<!--领款人证件号 -->
		<BankAccIDNo></BankAccIDNo>
		<!-- 业务类型: CT=退保，WT=犹退，CA=修改客户信息，MQ=满期，XQ=续期 -->
		<EdorType>CA</EdorType>
		<!-- 查询=1;确认=2 -->
		<EdorFlag>2</EdorFlag>
	</PubContInfo>
	
	<!-- 保全信息公共节点 -->
	<PubEdorInfo>
		<!-- 申请退保日期[yyyy-MM-dd] -->
		<EdorAppDate>
			<xsl:value-of select="java:com.sinosoft.midplat.common.DateUtil.getCur10Date()" />
		</EdorAppDate>
		<!-- 申请人姓名-->
		<EdorAppName><xsl:value-of select="Plchd_Nm" /></EdorAppName>
		<Certify>
			<!-- 单证类型( 1-保全申请书 9-其它) -->	<!-- 确认交易时为必填项 -->
			<CertifyType>1</CertifyType>                        	
			<!-- 单证名称(保全申请书号码) -->	    	<!-- 确认交易时为必填项 -->
			<CertifyName></CertifyName>           	
			<!-- 单证印刷号(1-保全申请书号码)-->		<!-- 确认交易时为必填项 -->
			<CertifyCode><xsl:value-of select="Btch_Bl_Prt_No" /></CertifyCode>
		</Certify>
	</PubEdorInfo>
	
	<EdorCAInfo> 
		<!--  投保人地址 -->
		<AppntPostalAddress><xsl:value-of select="Plchd_Comm_Adr" /></AppntPostalAddress>
		<!-- 投保人邮编 -->     
		<AppntZipCode><xsl:value-of select="Plchd_ZipECD" /></AppntZipCode>
		<!-- 投保人移动电话 -->
		<AppntMobile><xsl:value-of select="Plchd_Move_TelNo" /></AppntMobile>
		<!-- 投保人电话 -->
		<xsl:if test="PlchdFixTelDmstDstcNo != '' " >
		    <AppntPhone><xsl:value-of select="PlchdFixTelDmstDstcNo" />-<xsl:value-of select="Plchd_Fix_TelNo" /></AppntPhone>
		</xsl:if>
		<xsl:if test="PlchdFixTelDmstDstcNo = '' " >
		    <AppntPhone><xsl:value-of select="Plchd_Fix_TelNo" /></AppntPhone>
		</xsl:if>
	</EdorCAInfo> 
	
</xsl:template>

<!-- 证件类型转换 -->
<xsl:template name="tran_IDType">
	<xsl:param name="idtype" />
	<xsl:choose>
		<xsl:when test="$idtype='1010'">0</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1011'">0</xsl:when>	<!-- 身份证 -->
		<xsl:when test="$idtype='1052'">1</xsl:when>	<!-- 护照 -->
		<xsl:when test="$idtype='1020'">2</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='1030'">2</xsl:when>	<!-- 军官证 -->
		<xsl:when test="$idtype='1040'">5</xsl:when>	<!-- 户口簿 -->
		<xsl:when test="$idtype=''">9</xsl:when>	<!-- 异常身份证 -->
		<xsl:otherwise>8</xsl:otherwise><!-- 其他 -->
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
