package com.sinosoft.midplat.bcomm.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

/**   
 * @Title: NewContForNetBankOutXsl.java 
 * @Package com.sinosoft.midplat.bcomm.format 
 * @Description: 加载交行网银新单试算报文格式转换文件，核心-->银行 
 * @date Jan 5, 2016 3:51:35 PM 
 * @version V1.0   
 */

public class NewContForNetBankOutXsl extends XslCache {

	private static NewContForNetBankOutXsl cThisIns = new NewContForNetBankOutXsl();
	
	private String cPath = "com/sinosoft/midplat/bcomm/format/NewContForNetBankOut.xsl";
	
	private NewContForNetBankOutXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {
		cLogger.info("Into NewContForNetBankOutXsl.load()...");
		
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
		
		cLogger.info("Out NewContForNetBankOutXsl.load()!");
	}
	
	public static NewContForNetBankOutXsl newInstance() {
		return cThisIns;
	}

}
