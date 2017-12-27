package com.coway.trust.web.common.excel.upload;

import java.text.SimpleDateFormat;

import com.coway.trust.web.common.excel.ExcelCellValues;

public class ExcelUploadColumnVo {
	private String columnName;
	private ExcelCellValues.Types valueType;

	private Object valueFormat;

	public String getColumnName() {
		return columnName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public ExcelCellValues.Types getValueType() {
		return valueType;
	}

	public void setValueType(ExcelCellValues.Types valueType) {
		this.valueType = valueType;
		if (this.valueType == ExcelCellValues.Types.DATE || this.valueType == ExcelCellValues.Types.CALENDAR
				|| this.valueType == ExcelCellValues.Types.TIMESTAMP) {
			throw new RuntimeException(
					"(DATE, TIMESTAMP, CALENDAR) type must to use 'setValueType(ValueType valueType, String format)'! ");
		}
		valueFormat = null;
	}

	public void setValueType(ExcelCellValues.Types valueType, String format) {
		this.valueType = valueType;
		switch (this.valueType) {
		case DATE:
			valueFormat = new SimpleDateFormat(format);
			break;
		case CALENDAR:
			valueFormat = new SimpleDateFormat(format);
			break;
		case TIMESTAMP:
			valueFormat = new SimpleDateFormat(format);
			break;
		default:
			valueFormat = null;
			break;
		}
	}

	public Object getValueFormat() {
		return valueFormat;
	}
}
