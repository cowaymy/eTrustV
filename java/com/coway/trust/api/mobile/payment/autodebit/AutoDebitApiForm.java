package com.coway.trust.api.mobile.payment.autodebit;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "AutoDebitApiForm", description = "AutoDebitApiForm")
public class AutoDebitApiForm {
	private String salesOrdNo;
	private String dateFrom;
	private String dateTo;
	private String statusCode;
	private String custId;
	private String thirdPartyCustId;
	private String newCustCreditCardId;
	private String isThirdPartyPayment;
	private String signData;
	private String createdBy;
	private String monthlyRentalAmount;
	private String atchFileGroupId;
    private String subPath;
    private String fileKeySeq;
    private String sms1;
    private String sms2;
    private String email1;
    private String email2;
    private String userName;

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
		if(vo.getSignData() != null && vo.getSignData().length() > 0){
			params.put("signData", Base64.decodeBase64(vo.getSignData()));
		}
		else{
			params.put("signData", vo.getSignData());
		}
		params.put("fileKeySeq", vo.getSignData());
		params.put("atchFileGroupId", vo.getAtchFileGroupId());
		params.put("sms1", vo.getSms1());
		params.put("sms2", vo.getSms2());
		params.put("email1", vo.getEmail1());
		params.put("email2", vo.getEmail2());
		params.put("userName", vo.getUserName());
		params.put("thirdPartyCustId", vo.getThirdPartyCustId());
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

	public String getSms1() {
		return sms1;
	}

	public void setSms1(String sms1) {
		this.sms1 = sms1;
	}

	public String getSms2() {
		return sms2;
	}

	public void setSms2(String sms2) {
		this.sms2 = sms2;
	}

	public String getEmail1() {
		return email1;
	}

	public void setEmail1(String email1) {
		this.email1 = email1;
	}

	public String getEmail2() {
		return email2;
	}

	public void setEmail2(String email2) {
		this.email2 = email2;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getThirdPartyCustId() {
		return thirdPartyCustId;
	}

	public void setThirdPartyCustId(String thirdPartyCustId) {
		this.thirdPartyCustId = thirdPartyCustId;
	}
}
