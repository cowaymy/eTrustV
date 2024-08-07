package com.coway.trust.biz.logistics.calendar;

import org.apache.commons.csv.CSVRecord;

public class CalendarEventVO {

	private String date;
	private String agenda;

	public static CalendarEventVO create(CSVRecord CSVRecord) {
		CalendarEventVO vo = new CalendarEventVO();
		vo.setDate(CSVRecord.get(0));
		vo.setAgenda(CSVRecord.get(1));
		return vo;

	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getAgenda() {
		return agenda;
	}

	public void setAgenda(String agenda) {
		this.agenda = agenda;
	}

}
