package com.coway.trust.api.mobile.payment.autodebit;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "AutoDebitApiForm", description = "AutoDebitApiForm")
public class AutoDebitApiForm {
	private int salesOrdNo;
	private String dateFrom;
	private String dateTo;
	private int statusCode;
	private int custId;
	private int newCustCreditCardId;
	private int isThirdPartyPayment;
	private String signData;
	private int createdBy;
	private int monthlyRentalAmount;
	private int atchFileGroupId;
    private String subPath;
    private int fileKeySeq;

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

	public int getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(int salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
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

	public int getStatusCode() {
		return statusCode;
	}

	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public int getNewCustCreditCardId() {
		return newCustCreditCardId;
	}

	public void setNewCustCreditCardId(int newCustCreditCardId) {
		this.newCustCreditCardId = newCustCreditCardId;
	}

	public int getIsThirdPartyPayment() {
		return isThirdPartyPayment;
	}

	public void setIsThirdPartyPayment(int isThirdPartyPayment) {
		this.isThirdPartyPayment = isThirdPartyPayment;
	}

	public String getSignData() {
		return signData;
	}

	public void setSignData(String signData) {
		this.signData = signData;
	}

	public int getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
	}

	public int getMonthlyRentalAmount() {
		return monthlyRentalAmount;
	}

	public void setMonthlyRentalAmount(int monthlyRentalAmount) {
		this.monthlyRentalAmount = monthlyRentalAmount;
	}

	public int getAtchFileGroupId() {
		return atchFileGroupId;
	}

	public void setAtchFileGroupId(int atchFileGroupId) {
		this.atchFileGroupId = atchFileGroupId;
	}

	public String getSubPath() {
		return subPath;
	}

	public void setSubPath(String subPath) {
		this.subPath = subPath;
	}

	public int getFileKeySeq() {
		return fileKeySeq;
	}

	public void setFileKeySeq(int fileKeySeq) {
		this.fileKeySeq = fileKeySeq;
	}


}
