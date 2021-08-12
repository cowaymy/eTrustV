package com.coway.trust.web.common.excel.download;

import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.xssf.usermodel.XSSFColor;

public class ExcelDownloadHeaderVO {
	private String titleName;
	HorizontalAlignment valueAlign;
	private XSSFColor foregroundColor;
	int rowIndex;
	int columnIndex;
	int rows;
	int columns;

	public ExcelDownloadHeaderVO() {
	}

	public XSSFColor getForegroundColor() {
		return foregroundColor;
	}

	public void setForegroundColor(XSSFColor foregroundColor) {
		this.foregroundColor = foregroundColor;
	}

	public String getTitleName() {
		return titleName;
	}

	public void setTitleName(String titleName) {
		this.titleName = titleName;
	}

	public HorizontalAlignment getValueAlign() {
		return valueAlign;
	}

	public void setValueAlign(HorizontalAlignment valueAlign) {
		this.valueAlign = valueAlign;
	}

	public int getRowIndex() {
		return rowIndex;
	}

	public void setRowColumnInfo(int rowIndex, int rows, int columnIndex, int columns) {
		this.rowIndex = rowIndex;
		this.columnIndex = columnIndex;
		this.rows = rows;
		this.columns = columns;
	}

	public void setRowColumnIndex(int rowIndex, int columnIndex) {
		this.rowIndex = rowIndex;
		this.columnIndex = columnIndex;
	}

	public void setRowIndex(int rowIndex) {
		this.rowIndex = rowIndex;
	}

	public int getColumnIndex() {
		return columnIndex;
	}

	public void setColumnIndex(int columnIndex) {
		this.columnIndex = columnIndex;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	public void setColumns(int columns) {
		this.columns = columns;
	}

	public void setRowColumns(int rows, int columns) {
		this.rows = rows;
		this.columns = columns;
	}

	public int getRows() {
		return rows;
	}

	public int getColumns() {
		return columns;
	}
}
