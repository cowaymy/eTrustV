package com.coway.trust.biz.payment.autodebit.service;

public class EnrollmentUpdateDVO {
	private int enrollUpdateDetId;
	private int enrollUpdateId;
	private int statusCodeId;
	private String orderNo;
	private int salesOrderId;
	private int appTypeId;
	private String inputMonth;
	private String inputDay;
	private String inputYear;
	private String resultDate;
	private String created;
	private int creator;
	private String message;
	private String inputRejectCode;
	private int rejectCodeId;
	private int serviceContractId;
	public int getEnrollUpdateDetId() {
		return enrollUpdateDetId;
	}
	public void setEnrollUpdateDetId(int enrollUpdateDetId) {
		this.enrollUpdateDetId = enrollUpdateDetId;
	}
	public int getEnrollUpdateId() {
		return enrollUpdateId;
	}
	public void setEnrollUpdateId(int enrollUpdateId) {
		this.enrollUpdateId = enrollUpdateId;
	}
	public int getStatusCodeId() {
		return statusCodeId;
	}
	public void setStatusCodeId(int statusCoeId) {
		this.statusCodeId = statusCoeId;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public int getSalesOrderId() {
		return salesOrderId;
	}
	public void setSalesOrderId(int salesOrderId) {
		this.salesOrderId = salesOrderId;
	}
	public int getAppTypeId() {
		return appTypeId;
	}
	public void setAppTypeId(int appTypeId) {
		this.appTypeId = appTypeId;
	}
	public String getInputMonth() {
		return inputMonth;
	}
	public void setInputMonth(String inputMonth) {
		this.inputMonth = inputMonth;
	}
	public String getInputDay() {
		return inputDay;
	}
	public void setInputDay(String inputDay) {
		this.inputDay = inputDay;
	}
	public String getInputYear() {
		return inputYear;
	}
	public void setInputYear(String inputYear) {
		this.inputYear = inputYear;
	}
	public String getResultDate() {
		return resultDate;
	}
	public void setResultDate(String resultDate) {
		this.resultDate = resultDate;
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
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getInputRejectCode() {
		return inputRejectCode;
	}
	public void setInputRejectCode(String inputRejectCode) {
		this.inputRejectCode = inputRejectCode;
	}
	public int getRejectCodeId() {
		return rejectCodeId;
	}
	public void setRejectCodeId(int rejectCodeId) {
		this.rejectCodeId = rejectCodeId;
	}
	public int getServiceContractId() {
		return serviceContractId;
	}
	public void setServiceContractId(int serviceContractId) {
		this.serviceContractId = serviceContractId;
	}
	@Override
	public String toString() {
		return "EnrollmentUpdateDVO [enrollUpdateDetId=" + enrollUpdateDetId + ", enrollUpdateId=" + enrollUpdateId
				+ ", statusCodeId=" + statusCodeId + ", orderNo=" + orderNo + ", salesOrderId=" + salesOrderId
				+ ", appTypeId=" + appTypeId + ", inputMonth=" + inputMonth + ", inputDay=" + inputDay + ", inputYear="
				+ inputYear + ", resultDate=" + resultDate + ", created=" + created + ", creator=" + creator
				+ ", message=" + message + ", inputRejectCode=" + inputRejectCode + ", rejectCodeId=" + rejectCodeId
				+ ", serviceContractId=" + serviceContractId + "]";
	}
	
	
}
