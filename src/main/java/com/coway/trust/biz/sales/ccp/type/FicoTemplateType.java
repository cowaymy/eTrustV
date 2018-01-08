package com.coway.trust.biz.sales.ccp.type;

public enum FicoTemplateType {

	FICO_SCORE_TYPE("/template/stylesheet/fico_report.xsl"),
	CTOS_SCORE_TYPE("/template/stylesheet/ctos_report.xsl");
	
	private String filePath = "";
	
	FicoTemplateType(String filePath) {
		this.filePath = filePath;
	}
	
	public String getFilePath() {
		return filePath;
	}
	
}
