package com.sinosoft.midplat.grcb;

import java.io.File;

import com.sinosoft.midplat.MidplatConf;
import com.sinosoft.midplat.common.JdomUtil;
import com.sinosoft.midplat.common.SysInfo;
import com.sinosoft.midplat.common.XmlConf;
import com.sinosoft.midplat.common.cache.FileCacheManage;

public class GrcbConf extends XmlConf{

	private static final GrcbConf cThisIns = new GrcbConf();
	private static final String cPath = "conf/grcb.xml";
	
	private GrcbConf() {
		load();
		FileCacheManage.newInstance().register(cPath, this);
	}
	
	public void load() {

		cLogger.info("Into GrcbConf.load()...");
		
		String mFilePath = SysInfo.cHome + cPath;
		cLogger.info("Start load " + mFilePath + "...");
		
		cConfFile = new File(mFilePath);
		
		/**
		 * 一定要在加载之前记录文件属性。
		 * 文件的加载到文件属性设置之间存在细微的时间差，
		 * 如果恰巧在此时间差内外部修改了文件，
		 * 那么记录的数据就是新修改后的，导致这次修改不会自动被加载；
		 * 将文件属性设置放在加载之前，就算在时间差内文件发生改变，
		 * 由于记录的是旧的属性，系统会在下一个时间单元重新加载，
		 * 这样顶多会导致同一文件多加载一次，但不会出现修改而不被加载的bug。
		 */
		recordStatus();
		
		cConfDoc = loadXml(cConfFile);
		cLogger.info("End load " + mFilePath + "!");
		
		//是否输出配置文件
		if (MidplatConf.newInstance().outConf()) {
			cLogger.info(JdomUtil.toString(cConfDoc));
		}
		
		cLogger.info("Out GrcbConf.load()!");
	}
	
	public static GrcbConf newInstance() {
		return cThisIns;
	}
}

