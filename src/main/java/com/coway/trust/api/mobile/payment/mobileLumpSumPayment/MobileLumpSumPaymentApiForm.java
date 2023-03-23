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
		params.put("paymentMethod", vo.getPaymentMethodId());
		params.put("totalOriginalOutstandingAmount", vo.getTotalOriginalOutstandingAmount());
		params.put("totalPayableAmount", vo.getTotalPayableAmount());
		params.put("orderDetailList", createMap2(vo.getOrderDetailList()));

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

}
