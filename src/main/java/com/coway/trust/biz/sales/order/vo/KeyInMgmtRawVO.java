package com.coway.trust.biz.sales.order.vo;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;
import org.apache.poi.ss.usermodel.Row;
import org.apache.commons.csv.CSVRecord;

public class KeyInMgmtRawVO {

	private String year;
	private String month;
	private String week;
	private String keyInStartDt;
	private String keyInEndDt;

	public static KeyInMgmtRawVO create(CSVRecord CSVRecord) {

		KeyInMgmtRawVO vo = new KeyInMgmtRawVO();
			vo.setYear(CSVRecord.get(0));
			vo.setMonth(CSVRecord.get(1));
			vo.setWeek(CSVRecord.get(2));
			vo.setKeyInStartDt(CSVRecord.get(3));
			vo.setKeyInEndDt(CSVRecord.get(4));

			return vo;
	}

	@Override
	public String toString() {
		return "KeyInMgmtRawVO [year=" + year + ", month=" + month + ", week=" + week
				+ ", keyInStartDt=" + keyInStartDt + ", keyInEndDt=" + keyInEndDt + "]";
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
	}

	public String getWeek() {
		return week;
	}

	public void setWeek(String week) {
		this.week = week;
	}

	public String getKeyInStartDt() {
		return keyInStartDt;
	}

	public void setKeyInStartDt(String keyInStartDt) {
		this.keyInStartDt = keyInStartDt;
	}

	public String getKeyInEndDt() {
		return keyInEndDt;
	}

	public void setKeyInEndDt(String keyInEndDt) {
		this.keyInEndDt = keyInEndDt;
	}


}
