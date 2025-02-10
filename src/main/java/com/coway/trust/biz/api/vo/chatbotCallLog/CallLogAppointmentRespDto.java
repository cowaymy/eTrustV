package com.coway.trust.biz.api.vo.chatbotCallLog;

import java.util.List;

public class CallLogAppointmentRespDto {
	private boolean success;
	private int statusCode;
	private String message;
	private List<CallLogAppointmentDate> callLogAppointmentDates;

	public boolean isSuccess() {
		return success;
	}
	public void setSuccess(boolean success) {
		this.success = success;
	}
	public int getStatusCode() {
		return statusCode;
	}
	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}

	public List<CallLogAppointmentDate> getCallLogAppointmentDates() {
		return callLogAppointmentDates;
	}
	public void setCallLogAppointmentDates(List<CallLogAppointmentDate> callLogAppointmentDates) {
		this.callLogAppointmentDates = callLogAppointmentDates;
	}

	public static class CallLogAppointmentDate {
		private String aptDate;
		private int capacity;

		public String getAptDate() {
			return aptDate;
		}
		public void setAptDate(String aptDate) {
			this.aptDate = aptDate;
		}
		public int getCapacity() {
			return capacity;
		}
		public void setCapacity(int capacity) {
			this.capacity = capacity;
		}
	}
}
