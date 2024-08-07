package com.coway.trust.web.common.claim;

import java.util.List;

public class FileInfoVO {
	private String filePath;
	private String subFilePath;
	private String textFilename;
	private List<ColumnVO> textColumns;
	private List<HeaderVO> textHeaders;

	public List<HeaderVO> getTextHeaders() {
		return textHeaders;
	}

	public void setTextHeaders(List<HeaderVO> textHeaders) {
		this.textHeaders = textHeaders;
	}

	public List<ColumnVO> getTextColumns() {
		return textColumns;
	}

	public void setTextColumns(List<ColumnVO> textColumns) {
		this.textColumns = textColumns;
	}

	public String getTextFilename() {
		return textFilename;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getSubFilePath() {
		return subFilePath;
	}

	public void setSubFilePath(String subFilePath) {
		this.subFilePath = subFilePath;
	}

	public void setTextFilename(String textFilename) {
		this.textFilename = textFilename;
	}

}
