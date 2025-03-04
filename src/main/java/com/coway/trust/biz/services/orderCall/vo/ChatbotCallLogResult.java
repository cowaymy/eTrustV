package com.coway.trust.biz.services.orderCall.vo;

import java.util.List;

public class ChatbotCallLogResult {
	private boolean success;
	private List<Result> result;
	private int errorCode;
	private String error;

	public boolean isSuccess() {
		return success;
	}
	public void setSuccess(boolean success) {
		this.success = success;
	}
	public int getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}

	public List<Result> getResult() {
		return result;
	}
	public void setResult(List<Result> result) {
		this.result = result;
	}

	public static class Result
	{
		private String requestId;
		private String phoneNumber;
		private boolean sent;
		private String error;

		public String getRequestId() {
			return requestId;
		}
		public void setRequestId(String requestId) {
			this.requestId = requestId;
		}
		public String getPhoneNumber() {
			return phoneNumber;
		}
		public void setPhoneNumber(String phoneNumber) {
			this.phoneNumber = phoneNumber;
		}
		public boolean isSent() {
			return sent;
		}
		public void setSent(boolean sent) {
			this.sent = sent;
		}
		public String getError() {
			return error;
		}
		public void setError(String error) {
			this.error = error;
		}
	}
}
