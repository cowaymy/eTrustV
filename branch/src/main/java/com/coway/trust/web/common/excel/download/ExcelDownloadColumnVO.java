package com.coway.trust.web.common.excel.download;

import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.xssf.usermodel.XSSFColor;

public class ExcelDownloadColumnVO {
	private String columnName;
	HorizontalAlignment valueAlign;
	private XSSFColor foregroundColor;

	public XSSFColor getForegroundColor() {
		return foregroundColor;
	}

	public void setForegroundColor(XSSFColor foregroundColor) {
		this.foregroundColor = foregroundColor;
	}

	public String getColumnName() {
		return columnName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public HorizontalAlignment getValueAlign() {
		return valueAlign;
	}

	public void setValueAlign(HorizontalAlignment valueAlign) {
		this.valueAlign = valueAlign;
	}
}
