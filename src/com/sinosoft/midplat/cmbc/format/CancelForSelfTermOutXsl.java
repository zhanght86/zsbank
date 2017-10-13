package com.sinosoft.midplat.cmbc.format;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XslCache;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class CancelForSelfTermOutXsl extends XslCache {

	private static CancelForSelfTermOutXsl cThisIns = new CancelForSelfTermOutXsl();

	private String cPath = "com/sinosoft/midplat/cmbc/format/CancelForSelfTermOut.xsl";

	private CancelForSelfTermOutXsl() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}

	public void load() {
		cLogger.info("Into CancelForSelfTermOutXsl.load()...");

		String mFilePath = SysInfo.cBasePath + cPath;
		cLogger.info("Start load " + mFilePath + "...");

		cXslFile = new File(mFilePath);

		recordStatus();

		cXslTrsf = loadXsl(cXslFile);
		
		cLogger.info("End load " + mFilePath + "!");

		// �Ƿ����xsl�ļ�
		if (MidplatConf.newInstance().outConf()) {
			try {
				cLogger.info(JdomUtil.toString(JdomUtil.build(new FileInputStream(cXslFile)), ""));
			} catch (IOException ex) {
				cLogger.error("���xsl�쳣��", ex);
			}
		}

		cLogger.info("Out CancelForSelfTermOutXsl.load()!");
	}

	public static CancelForSelfTermOutXsl newInstance() {
		return cThisIns;
	}

}