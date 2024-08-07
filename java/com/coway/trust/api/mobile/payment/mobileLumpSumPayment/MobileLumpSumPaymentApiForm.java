package com.coway.trust.api.mobile.payment.mobileLumpSumPayment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "MobileLumpSumPaymentApiForm", description = "MobileLumpSumPaymentApiForm")
public class MobileLumpSumPaymentApiForm {
	//Customer Search
	private String custCiType;
	private String custCi;
	private String ordNoList;

	//Order Search
	private int custId;

	//Submit Data
	private String userName;
	private String signData;
	private String sms1;
    private String sms2;
    private String email1;
    private String email2;
    private int paymentMethodId;
    private Double totalOriginalOutstandingAmount;
    private Double totalPayableAmount;

    //upload image
    private int uploadImg1;
    private int uploadImg2;
    private int uploadImg3;
    private int uploadImg4;

    //Search cash matching
    private String fromDate;
    private String toDate;

    //Submit cash matching info
    private String mobPayGroupNo;
    private String slipNo;
    private String status;

    //Submit cheque info
    private int issueBank;
    private String chequeNo;
    private String chequeDate;

    //Submit credit card info
    private String cardNo;
    private String approvalNo;
    private String crcName;
    private String transactionDate;
    private String expiryDate;
    private int cardMode;
    private int merchantBank;
    private int cardBrand;

    private List<MobileLumpSumPaymentOrderDetailsForm> orderDetailList;

	public static Map<String, Object> createMap(MobileLumpSumPaymentApiForm vo){
    	Map<String, Object> params = new HashMap<>();
    	//Customer Search
    	params.put("custCiType", vo.getCustCiType());
    	params.put("custCi", vo.getCustCi());

    	//Order Search
    	params.put("custId", vo.getCustId());
    	params.put("ordNoList", vo.getOrdNoList());

    	//Submission Save
    	params.put("userName", vo.getUserName());
    	if(vo.getSignData() != null && vo.getSignData().length() > 0){
			params.put("signData", Base64.decodeBase64(vo.getSignData()));
		}
		else{
			params.put("signData", vo.getSignData());
		}
		params.put("sms1", vo.getSms1());
		params.put("sms2", vo.getSms2());
		params.put("email1", vo.getEmail1());
		params.put("email2", vo.getEmail2());
		params.put("paymentMethodId", vo.getPaymentMethodId());
		params.put("totalOriginalOutstandingAmount", vo.getTotalOriginalOutstandingAmount());
		params.put("totalPayableAmount", vo.getTotalPayableAmount());
		params.put("orderDetailList", createMap2(vo.getOrderDetailList()));

		//search cash matching
		params.put("fromDate", vo.getFromDate());
		params.put("toDate", vo.getToDate());
		params.put("status", vo.getStatus());

		//upload image
		params.put("uploadImg1", vo.getUploadImg1());
		params.put("uploadImg2", vo.getUploadImg2());
		params.put("uploadImg3", vo.getUploadImg3());
		params.put("uploadImg4", vo.getUploadImg4());

		//update cash matching
		params.put("mobPayGroupNo", vo.getMobPayGroupNo());
		params.put("slipNo", vo.getSlipNo());

		//update cheque
		params.put("issueBank", vo.getIssueBank());
		params.put("chequeNo", vo.getChequeNo());
		params.put("chequeDate", vo.getChequeDate());

		//update credit card
		params.put("cardNo",vo.getCardNo());
		params.put("approvalNo",vo.getApprovalNo());
		params.put("crcName",vo.getCrcName());
		params.put("transactionDate",vo.getTransactionDate());
		params.put("expiryDate",vo.getExpiryDate());
		params.put("cardMode",vo.getCardMode());
		params.put("merchantBank",vo.getMerchantBank());
		params.put("cardBrand",vo.getCardBrand());

		return params;
	}

	public static List<Object> createMap2(List<MobileLumpSumPaymentOrderDetailsForm> vo){
		List<Object> paramList = new ArrayList<>();
		if(vo!=null){
			for(MobileLumpSumPaymentOrderDetailsForm data : vo){
				Map<String, Object> params = new HashMap<>();
				params.put("ordId", data.getOrdId());
				params.put("ordNo", data.getOrdNo());
				params.put("ordPaymentTypeId", data.getOrdPaymentTypeId());
				params.put("ordPaymentTypeName", data.getOrdPaymentTypeName());
				params.put("payType", data.getPayType());
				params.put("otstndAmt", data.getOtstndAmt());
				params.put("inputOtstndAmt", data.getInputOtstndAmt());
				params.put("custId", data.getCustId());
				params.put("nric", data.getNric());
				params.put("ordTypeId", data.getOrdTypeId());
				params.put("ordTypeName", data.getOrdTypeName());
				params.put("srvMemId", data.getSrvMemId());
				paramList.add(params);
			}
		}
    	return paramList;
	}

	public String getCustCiType() {
		return custCiType;
	}
	public void setCustCiType(String custCiType) {
		this.custCiType = custCiType;
	}
	public String getCustCi() {
		return custCi;
	}
	public void setCustCi(String custCi) {
		this.custCi = custCi;
	}
	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getOrdNoList() {
		return ordNoList;
	}

	public void setOrdNoList(String ordNoList) {
		this.ordNoList = ordNoList;
	}

	public String getSignData() {
		return signData;
	}

	public void setSignData(String signData) {
		this.signData = signData;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
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

	public Double getTotalOriginalOutstandingAmount() {
		return totalOriginalOutstandingAmount;
	}

	public void setTotalOriginalOutstandingAmount(Double totalOriginalOutstandingAmount) {
		this.totalOriginalOutstandingAmount = totalOriginalOutstandingAmount;
	}

	public Double getTotalPayableAmount() {
		return totalPayableAmount;
	}

	public void setTotalPayableAmount(Double totalPayableAmount) {
		this.totalPayableAmount = totalPayableAmount;
	}

	public List<MobileLumpSumPaymentOrderDetailsForm> getOrderDetailList() {
		return orderDetailList;
	}

	public void setOrderDetailList(List<MobileLumpSumPaymentOrderDetailsForm> orderDetailList) {
		this.orderDetailList = orderDetailList;
	}

	public int getPaymentMethodId() {
		return paymentMethodId;
	}

	public void setPaymentMethodId(int paymentMethodId) {
		this.paymentMethodId = paymentMethodId;
	}

	public String getMobPayGroupNo() {
		return mobPayGroupNo;
	}

	public void setMobPayGroupNo(String mobPayGroupNo) {
		this.mobPayGroupNo = mobPayGroupNo;
	}

	public String getSlipNo() {
		return slipNo;
	}

	public void setSlipNo(String slipNo) {
		this.slipNo = slipNo;
	}

	public int getUploadImg1() {
		return uploadImg1;
	}

	public void setUploadImg1(int uploadImg1) {
		this.uploadImg1 = uploadImg1;
	}

	public int getUploadImg2() {
		return uploadImg2;
	}

	public void setUploadImg2(int uploadImg2) {
		this.uploadImg2 = uploadImg2;
	}

	public int getUploadImg3() {
		return uploadImg3;
	}

	public void setUploadImg3(int uploadImg3) {
		this.uploadImg3 = uploadImg3;
	}

	public String getFromDate() {
		return fromDate;
	}

	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}

	public String getToDate() {
		return toDate;
	}

	public void setToDate(String toDate) {
		this.toDate = toDate;
	}

	public int getIssueBank() {
		return issueBank;
	}

	public void setIssueBank(int issueBank) {
		this.issueBank = issueBank;
	}

	public String getChequeDate() {
		return chequeDate;
	}

	public void setChequeDate(String chequeDate) {
		this.chequeDate = chequeDate;
	}

	public int getUploadImg4() {
		return uploadImg4;
	}

	public void setUploadImg4(int uploadImg4) {
		this.uploadImg4 = uploadImg4;
	}

	public String getCardNo() {
		return cardNo;
	}

	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	public String getApprovalNo() {
		return approvalNo;
	}

	public void setApprovalNo(String approvalNo) {
		this.approvalNo = approvalNo;
	}

	public String getCrcName() {
		return crcName;
	}

	public void setCrcName(String crcName) {
		this.crcName = crcName;
	}

	public String getTransactionDate() {
		return transactionDate;
	}

	public void setTransactionDate(String transactionDate) {
		this.transactionDate = transactionDate;
	}

	public String getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}

	public int getCardMode() {
		return cardMode;
	}

	public void setCardMode(int cardMode) {
		this.cardMode = cardMode;
	}

	public int getMerchantBank() {
		return merchantBank;
	}

	public void setMerchantBank(int merchantBank) {
		this.merchantBank = merchantBank;
	}

	public int getCardBrand() {
		return cardBrand;
	}

	public void setCardBrand(int cardBrand) {
		this.cardBrand = cardBrand;
	}

	public String getChequeNo() {
		return chequeNo;
	}

	public void setChequeNo(String chequeNo) {
		this.chequeNo = chequeNo;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
