package com.sinosoft.midplat.bjrcb.format;

import org.jdom.Document;
import org.jdom.Element;

import com.sinosoft.midplat.format.XmlSimpFormat;

public class RePrint extends XmlSimpFormat {
	public RePrint(Element pThisBusiConf) {
		super(pThisBusiConf);
	}

	public Document noStd2Std(Document pNoStdXml) throws Exception {
		cLogger.info("Into RePrint.noStd2Std()...");

		Document mStdXml = RePrintInXsl.newInstance().getCache().transform(
				pNoStdXml);
		cLogger.info("Out RePrint.noStd2Std()!");
		return mStdXml;
	}

	public Document std2NoStd(Document pStdXml) throws Exception {
		cLogger.info("Into RePrint.std2NoStd()...");

		// �ش���µ����ر��Ļ�����ȫһ��������ֱ�ӵ���
		ContConfirm mContConfirm = new ContConfirm(cThisBusiConf);
		Document mNoStdXml = mContConfirm.std2NoStd(pStdXml);

		cLogger.info("Out RePrint.std2NoStd()!");
		return mNoStdXml;
	}
}