<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:java="http://xml.apache.org/xslt/java" 
    exclude-result-prefixes="java">
    
	<xsl:template match="/TranData">
		<InsuRet>
		<Main>
		    <xsl:if test="Head/Flag='0'">
		       <ResultCode>0000</ResultCode>
		       <ResultInfo><xsl:value-of select="Head/Desc"/></ResultInfo>
			   <PolicyNo></PolicyNo>		   
		    </xsl:if>
		    <xsl:if test="Head/Flag!='0'">
		       <ResultCode>0001</ResultCode>
		       <ResultInfo><xsl:value-of select="Head/Desc"/></ResultInfo>
			   <PolicyNo></PolicyNo>	   
		    </xsl:if>		
		 </Main>
		</InsuRet>
	</xsl:template>
	
</xsl:stylesheet>