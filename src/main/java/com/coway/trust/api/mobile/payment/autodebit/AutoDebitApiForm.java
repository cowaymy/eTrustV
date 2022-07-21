package com.coway.trust.api.mobile.payment.autodebit;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "AutoDebitApiForm", description = "AutoDebitApiForm")
public class AutoDebitApiForm {
	private String salesOrdNo;
	private String dateFrom;
	private String dateTo;
	private String statusCode;
	private String custId;
	private String newCustCreditCardId;
	private String isThirdPartyPayment;
	private String signData;
	private String createdBy;
	private String monthlyRentalAmount;
	private String atchFileGroupId;
    private String subPath;
    private String fileKeySeq;

	public static Map<String, Object> createMap(AutoDebitApiForm vo){
		Map<String, Object> params = new HashMap<>();

		params.put("salesOrdNo", vo.getSalesOrdNo());
		params.put("dateFrom", vo.getDateFrom());
		params.put("dateTo", vo.getDateTo());
		params.put("statusCode", vo.getStatusCode());
		params.put("custId", vo.getCustId());
		params.put("newCustCreditCardId", vo.getNewCustCreditCardId());
		params.put("isThirdPartyPayment", vo.getIsThirdPartyPayment());
		params.put("createdBy", vo.getCreatedBy());
		params.put("monthlyRentalAmount", vo.getMonthlyRentalAmount());
		return params;
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

	public String getStatusCode() {
		return statusCode;
	}

	public void setStatusCode(String statusCode) {
		this.statusCode = statusCode;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getNewCustCreditCardId() {
		return newCustCreditCardId;
	}

	public void setNewCustCreditCardId(String newCustCreditCardId) {
		this.newCustCreditCardId = newCustCreditCardId;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getIsThirdPartyPayment() {
		return isThirdPartyPayment;
	}

	public void setIsThirdPartyPayment(String isThirdPartyPayment) {
		this.isThirdPartyPayment = isThirdPartyPayment;
	}

	public String getSignData() {
		return signData;
	}

	public void setSignData(String signData) {
		this.signData = signData;
	}

	public String getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public String getMonthlyRentalAmount() {
		return monthlyRentalAmount;
	}

	public void setMonthlyRentalAmount(String monthlyRentalAmount) {
		this.monthlyRentalAmount = monthlyRentalAmount;
	}

	public String getAtchFileGroupId() {
		return atchFileGroupId;
	}

	public void setAtchFileGroupId(String atchFileGroupId) {
		this.atchFileGroupId = atchFileGroupId;
	}

	public String getSubPath() {
		return subPath;
	}

	public void setSubPath(String subPath) {
		this.subPath = subPath;
	}

	public String getFileKeySeq() {
		return fileKeySeq;
	}

	public void setFileKeySeq(String fileKeySeq) {
		this.fileKeySeq = fileKeySeq;
	}
}
