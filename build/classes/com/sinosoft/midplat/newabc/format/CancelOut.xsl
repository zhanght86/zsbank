<?xml version="1.0" encoding="GBK"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="java">

	<xsl:output indent='yes' />
	<xsl:template match="/TranData">
		<TranData>
			<xsl:copy-of select="Head" />
			<App>
				<Ret>
					<!-- ��ˮ�� -->
					<OrgSerialNo></OrgSerialNo>
				</Ret>
			</App>
		</TranData>
	</xsl:template>
</xsl:stylesheet>