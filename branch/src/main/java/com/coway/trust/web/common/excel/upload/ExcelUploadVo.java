package com.coway.trust.web.common.excel.upload;

import java.util.Map;

public class ExcelUploadVo {
	private int startRow;
	private int batchCount;
	private String type;

	private String dBHandler;
	private Map<String, ExcelUploadColumnVo> excelColumns;

	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getBatchCount() {
		return batchCount;
	}

	public void setBatchCount(int batchCount) {
		this.batchCount = batchCount;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDBHandler() {
		return dBHandler;
	}

	public void setDBHandler(String dBHandler) {
		this.dBHandler = dBHandler;
	}

	public Map<String, ExcelUploadColumnVo> getExcelColumns() {
		return excelColumns;
	}

	public void setExcelHeader(Map<String, ExcelUploadColumnVo> excelColumns) {
		this.excelColumns = excelColumns;
	}
}
