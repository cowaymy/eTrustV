package com.coway.trust.web.common.excel.download;

import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFColor;

public class ExcelDownloadVO {
	private List<ExcelDownloadColumnVO> excelColumns;
	private List<ExcelDownloadHeaderVO> excelHeaders;
	private String excelFilename;

	private boolean isBorder = true;
	private XSSFColor foregroundColor;

	private String headerFont;
	private String dataFont;
	private Short fontSize;

	private String title;
	private String titleFont;
	private Short titleFontSize;

	public List<ExcelDownloadHeaderVO> getExcelHeaders() {
		return excelHeaders;
	}

	public void setExcelHeaders(List<ExcelDownloadHeaderVO> excelHeaders) {
		this.excelHeaders = excelHeaders;
	}

	public XSSFColor getForegroundColor() {
		return foregroundColor;
	}

	public void setForegroundColor(XSSFColor backgroundColor) {
		this.foregroundColor = backgroundColor;
	}

	public boolean isBorder() {
		return isBorder;
	}

	public void setBorder(boolean isBorder) {
		this.isBorder = isBorder;
	}

	public List<ExcelDownloadColumnVO> getExcelColumns() {
		return excelColumns;
	}

	public void setExcelColumns(List<ExcelDownloadColumnVO> excelColumns) {
		this.excelColumns = excelColumns;
	}

	public String getExcelFilename() {
		return excelFilename;
	}

	public void setExcelFilename(String excelFilename) {
		this.excelFilename = excelFilename;
	}

	public String getHeaderFont() {
		return headerFont;
	}

	public void setHeaderFont(String headerFont) {
		this.headerFont = headerFont;
	}

	public String getDataFont() {
		return dataFont;
	}

	public void setDataFont(String dataFont) {
		this.dataFont = dataFont;
	}

	public Short getFontSize() {
		return fontSize;
	}

	public void setFontSize(Short fontSize) {
		this.fontSize = fontSize;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getTitleFont() {
		return titleFont;
	}

	public void setTitleFont(String titleFont) {
		this.titleFont = titleFont;
	}

	public Short getTitleFontSize() {
		return titleFontSize;
	}

	public void setTitleFontSize(Short titleFontSize) {
		this.titleFontSize = titleFontSize;
	}
}
