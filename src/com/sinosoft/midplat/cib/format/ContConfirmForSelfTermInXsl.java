package com.sinosoft.midplat.cib.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class ContConfirmForSelfTermInXsl extends XslCache {

	private static ContConfirmForSelfTermInXsl cThisIns = new ContConfirmForSelfTermInXsl();
	
	private String cPath = "com/sinosoft/midplat/cib/format/ContConfirmForSelfTermIn.xsl";
	
	private ContConfirmForSelfTermInXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {
		cLogger.info("Into ContConfirmForSelfTermInXsl.load()...");
		
		String mFilePath = SysInfo.cBasePath + cPath;
		cLogger.info("Start load " + mFilePath + "...");
		
		cXslFile = new File(mFilePath);
		
		recordStatus();
		
		cXslTrsf = loadXsl(cXslFile);
		cLogger.info("End load " + mFilePath + "!");
		
		//是否输出xsl文件
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(JdomUtil.toString(JdomUtil.build(new FileInputStream(cXslFile)), ""));
			} catch (IOException ex) {
				cLogger.error("输出xsl异常！", ex);
			}
		}
		
		cLogger.info("Out ContConfirmForSelfTermInXsl.load()!");
	}
	
	public static ContConfirmForSelfTermInXsl newInstance() {
		return cThisIns;
	}
}
