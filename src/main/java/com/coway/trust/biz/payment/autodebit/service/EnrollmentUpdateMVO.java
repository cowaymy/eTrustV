package com.coway.trust.biz.payment.autodebit.service;

public class EnrollmentUpdateMVO {
	private int enrollUpdateId;
	private int typeId;
	private String created;
	private int creator;
	private int totalUpdate;
	private int totalSuccess;
	private int totalFail;
	private int enrollTypeId;
	public int getEnrollUpdateId() {
		return enrollUpdateId;
	}
	public void setEnrollUpdateId(int enrollUpdateId) {
		this.enrollUpdateId = enrollUpdateId;
	}
	public int getTypeId() {
		return typeId;
	}
	public void setTypeId(int typeId) {
		this.typeId = typeId;
	}
	public String getCreated() {
		return created;
	}
	public void setCreated(String created) {
		this.created = created;
	}
	public int getCreator() {
		return creator;
	}
	public void setCreator(int creator) {
		this.creator = creator;
	}
	public int getTotalUpdate() {
		return totalUpdate;
	}
	public void setTotalUpdate(int totalUpdate) {
		this.totalUpdate = totalUpdate;
	}
	public int getTotalSuccess() {
		return totalSuccess;
	}
	public void setTotalSuccess(int totalSuccess) {
		this.totalSuccess = totalSuccess;
	}
	public int getTotalFail() {
		return totalFail;
	}
	public void setTotalFail(int totalFail) {
		this.totalFail = totalFail;
	}
	public int getEnrollTypeId() {
		return enrollTypeId;
	}
	public void setEnrollTypeId(int enrollTypeId) {
		this.enrollTypeId = enrollTypeId;
	}
	
	
}
