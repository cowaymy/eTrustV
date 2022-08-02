package com.coway.trust.biz.attendance.impl;

import org.apache.commons.csv.CSVRecord;

public class CalendarEventVO {

	private String memCode;
	private String dateFrom;
	private String dateTo;
	private String time;
	private String atdType;

	public static CalendarEventVO create(CSVRecord CSVRecord) {
		CalendarEventVO vo = new CalendarEventVO();
		vo.setMemCode(CSVRecord.get(0));
		vo.setDateFrom(CSVRecord.get(1));
		vo.setDateTo(CSVRecord.get(2));
		vo.setTime(CSVRecord.get(3));
		vo.setAttendanceType(CSVRecord.get(4));
		return vo;

	}

	public String getMemCode() {
		return memCode;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}

	public String getDateFrom() {
		return dateFrom;
	}

	public void setDateFrom(String dateFrom) {
		this.dateFrom = dateFrom;
	}

	public String getDateTo() {
		return dateTo;
	}

	public void setDateTo(String dateTo) {
		this.dateTo = dateTo;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getAttendanceType() {
		return atdType;
	}

	public void setAttendanceType(String atdType) {
		this.atdType = atdType;
	}
}
