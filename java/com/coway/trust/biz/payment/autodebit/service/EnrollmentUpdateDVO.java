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
	// Added for eMandate-paperless by Hui Ding, 25/08/2023
	private String ddPaymentId;
	// Added for eMandate-paperless bug fixes by Hui Ding - ticket no: #24033069
	private String accNo;
	private String accType;
	private String accHolder;
	private String issueBank;
	private String startDate;
	private String rejectDate;
	private String submitDate;


	public String getSubmitDate() {
		return submitDate;
	}
	public void setSubmitDate(String submitDate) {
		this.submitDate = submitDate;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getRejectDate() {
		return rejectDate;
	}
	public void setRejectDate(String rejectDate) {
		this.rejectDate = rejectDate;
	}
	public String getAccNo() {
		return accNo;
	}
	public void setAccNo(String accNo) {
		this.accNo = accNo;
	}
	public String getAccType() {
		return accType;
	}
	public void setAccType(String accType) {
		this.accType = accType;
	}
	public String getAccHolder() {
		return accHolder;
	}
	public void setAccHolder(String accHolder) {
		this.accHolder = accHolder;
	}
	public String getIssueBank() {
		return issueBank;
	}
	public void setIssueBank(String issueBank) {
		this.issueBank = issueBank;
	}
	public String getDdPaymentId() {
		return ddPaymentId;
	}
	public void setDdPaymentId(String ddPaymentId) {
		this.ddPaymentId = ddPaymentId;
	}
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
