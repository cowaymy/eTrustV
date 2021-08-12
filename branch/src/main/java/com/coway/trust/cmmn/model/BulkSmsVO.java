package com.coway.trust.cmmn.model;

public class BulkSmsVO {

	public BulkSmsVO(int userId, int smsType) {
		this.userId = userId;
		this.smsType = smsType;
	}

	private int userId;
	private int priority = 1;
	private int expireDayAdd = 1;
	private int smsType;
	private int retryNo;
	private String remark;

	private String message;
	private String mobile;

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getPriority() {
		return priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	public int getExpireDayAdd() {
		return expireDayAdd;
	}

	public void setExpireDayAdd(int expireDayAdd) {
		this.expireDayAdd = expireDayAdd;
	}

	public int getSmsType() {
		return smsType;
	}

	public void setSmsType(int smsType) {
		this.smsType = smsType;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public int getRetryNo() {
		return retryNo;
	}

	public void setRetryNo(int retryNo) {
		this.retryNo = retryNo;
	}
}
