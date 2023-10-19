/**
 *
 * @author HQIT-HUIDING
 * Oct 18, 2023
 */
package com.coway.trust.biz.payment.eMandate.service;

/**
 * @author HQIT-HUIDING
 * Oct 18, 2023
 */
public class DdCsvFormatVO {

	private String paymentId;
	private String type;
	private String accNo;
	private String accType;
	private String accHolder;
	private String issueBank;
	private String startDate;
	private String rejectDate;
	private String rejectCode;
	private String status;

	public String getPaymentId() {
		return paymentId;
	}
	public void setPaymentId(String paymentId) {
		this.paymentId = paymentId;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
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
	public String getRejectCode() {
		return rejectCode;
	}
	public void setRejectCode(String rejectCode) {
		this.rejectCode = rejectCode;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	/**
	 *
	 * @author HQIT-HUIDING
	 * Oct 18, 2023
	 */
	public DdCsvFormatVO(String paymentId, String type, String accNo, String accType, String accHolder,
			String issueBank, String startDate, String rejectDate, String rejectCode, String status) {
		super();
		this.paymentId = paymentId;
		this.type = type;
		this.accNo = accNo;
		this.accType = accType;
		this.accHolder = accHolder;
		this.issueBank = issueBank;
		this.startDate = startDate;
		this.rejectDate = rejectDate;
		this.rejectCode = rejectCode;
		this.status = status;
	}

	@Override
	public String toString() {
		return "DdCsvFormatVO [paymentId=" + paymentId + ", type=" + type + ", accNo=" + accNo + ", accType=" + accType
				+ ", accHolder=" + accHolder + ", issueBank=" + issueBank + ", startDate=" + startDate + ", rejectDate="
				+ rejectDate + ", rejectCode=" + rejectCode + ", status=" + status + "]";
	}




}
