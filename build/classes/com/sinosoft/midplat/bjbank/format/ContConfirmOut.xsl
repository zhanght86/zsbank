<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">
	<xsl:template match="/">
		<TranData>
			<RetData>
				<ContNo><xsl:value-of select="TranData/Body/ContNo"/></ContNo>
				<xsl:variable name ="flag" select ="TranData/Head/Flag"/>
				<xsl:if test="$flag=0">
					<Flag>1</Flag>
				</xsl:if>
				<xsl:if test="$flag=1">
					<Flag>0</Flag>
				</xsl:if>
         		<Desc><xsl:value-of select="TranData/Head/Desc"/></Desc>
			</RetData>
		</TranData>
	</xsl:template>
	
</xsl:stylesheet>
