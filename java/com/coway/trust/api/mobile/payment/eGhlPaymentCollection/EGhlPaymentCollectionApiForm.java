package com.coway.trust.api.mobile.payment.eGhlPaymentCollection;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "EGhlPaymentCollectionApiForm", description = "EGhlPaymentCollectionApiForm")
public class EGhlPaymentCollectionApiForm {
	private List<Map<String,Object>> detailInfo;
	private String custIc;
	private String custId;
	private String userName;
	private String email;
	private String telNo;
	private String customerName;
	private String paymentLink;
	private String paymentRunningNumber;
	private String orderDescription;
	private String totalAmountPayable;

	private String salesOrdId;
	private String salesOrdNo;
	private String productOutstandingAmount;
	private String productTypeId;
	private String productTypeName;
	private String productTypeCode;
	private String membershipOutstandingAmount;
	private String membership;
	private String productId;
	private String productCode;
	private String productName;
	private String productBillChecked;
	private String svmBillChecked;
	private String payingAmount;

	private String transactionDateFrom;
	private String transactionDateTo;

	public static Map<String, Object> createMap(EGhlPaymentCollectionApiForm vo){
    	Map<String, Object> params = new HashMap<>();
    	params.put("detailInfo", vo.getDetailInfo());
    	params.put("custIc", vo.getCustIc());
    	params.put("custId", vo.getCustId());
    	params.put("userName", vo.getUserName());
    	params.put("email", vo.getEmail());
    	params.put("telNo", vo.getTelNo());
    	params.put("customerName", vo.getCustomerName());
    	params.put("paymentLink", vo.getPaymentLink());
    	params.put("paymentRunningNumber", vo.getPaymentRunningNumber());
    	params.put("orderDescription", vo.getOrderDescription());
    	params.put("totalAmountPayable", vo.getTotalAmountPayable());

    	params.put("salesOrdNo", vo.getSalesOrdNo());
    	params.put("transactionDateFrom", vo.getTransactionDateFrom());
    	params.put("transactionDateTo", vo.getTransactionDateTo());

    	return params;
	}

	public static List<Map<String, Object>> createMap2(List<EGhlPaymentCollectionApiForm> vo){
		List<Map<String, Object>> paramList = new ArrayList<>();
    	for(int i=0; i<vo.size();i++){
    		Map<String, Object> params = new HashMap<>();

        	params.put("userName", vo.get(i).getUserName());
        	params.put("salesOrdId", vo.get(i).getSalesOrdId());
        	params.put("salesOrdNo", vo.get(i).getSalesOrdNo());
        	params.put("productOutstandingAmount", vo.get(i).getProductOutstandingAmount());
        	params.put("productTypeName", vo.get(i).getProductTypeName());
        	params.put("productTypeCode", vo.get(i).getProductTypeCode());
        	params.put("membershipOutstandingAmount", vo.get(i).getMembershipOutstandingAmount());
        	params.put("membership", vo.get(i).getMembership());
        	params.put("productId", vo.get(i).getProductId());
        	params.put("productCode", vo.get(i).getProductCode());
        	params.put("productName", vo.get(i).getProductName());
        	params.put("productBillChecked", vo.get(i).getProductBillChecked());
        	params.put("svmBillChecked", vo.get(i).getSvmBillChecked());
        	params.put("payingAmount", vo.get(i).getPayingAmount());

        	paramList.add(params);
    	}

    	return paramList;
	}

	public String getCustIc() {
		return custIc;
	}

	public void setCustIc(String custIc) {
		this.custIc = custIc;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public List<Map<String,Object>> getDetailInfo() {
		return detailInfo;
	}

	public void setDetailInfo(List<Map<String,Object>> detailInfo) {
		this.detailInfo = detailInfo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getTelNo() {
		return telNo;
	}

	public void setTelNo(String telNo) {
		this.telNo = telNo;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getPaymentLink() {
		return paymentLink;
	}

	public void setPaymentLink(String paymentLink) {
		this.paymentLink = paymentLink;
	}

	public String getOrderDescription() {
		return orderDescription;
	}

	public void setOrderDescription(String orderDescription) {
		this.orderDescription = orderDescription;
	}

	public String getTotalAmountPayable() {
		return totalAmountPayable;
	}

	public void setTotalAmountPayable(String totalAmountPayable) {
		this.totalAmountPayable = totalAmountPayable;
	}

	public String getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(String salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getProductOutstandingAmount() {
		return productOutstandingAmount;
	}

	public void setProductOutstandingAmount(String productOutstandingAmount) {
		this.productOutstandingAmount = productOutstandingAmount;
	}

	public String getProductTypeId() {
		return productTypeId;
	}

	public void setProductTypeId(String productTypeId) {
		this.productTypeId = productTypeId;
	}

	public String getProductTypeName() {
		return productTypeName;
	}

	public void setProductTypeName(String productTypeName) {
		this.productTypeName = productTypeName;
	}

	public String getProductTypeCode() {
		return productTypeCode;
	}

	public void setProductTypeCode(String productTypeCode) {
		this.productTypeCode = productTypeCode;
	}

	public String getMembershipOutstandingAmount() {
		return membershipOutstandingAmount;
	}

	public void setMembershipOutstandingAmount(String membershipOutstandingAmount) {
		this.membershipOutstandingAmount = membershipOutstandingAmount;
	}

	public String getMembership() {
		return membership;
	}

	public void setMembership(String membership) {
		this.membership = membership;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getProductBillChecked() {
		return productBillChecked;
	}

	public void setProductBillChecked(String productBillChecked) {
		this.productBillChecked = productBillChecked;
	}

	public String getSvmBillChecked() {
		return svmBillChecked;
	}

	public void setSvmBillChecked(String svmBillChecked) {
		this.svmBillChecked = svmBillChecked;
	}

	public String getPayingAmount() {
		return payingAmount;
	}

	public void setPayingAmount(String payingAmount) {
		this.payingAmount = payingAmount;
	}

	public String getPaymentRunningNumber() {
		return paymentRunningNumber;
	}

	public void setPaymentRunningNumber(String paymentRunningNumber) {
		this.paymentRunningNumber = paymentRunningNumber;
	}

	public String getTransactionDateFrom() {
		return transactionDateFrom;
	}

	public void setTransactionDateFrom(String transactionDateFrom) {
		this.transactionDateFrom = transactionDateFrom;
	}

	public String getTransactionDateTo() {
		return transactionDateTo;
	}

	public void setTransactionDateTo(String transactionDateTo) {
		this.transactionDateTo = transactionDateTo;
	}
}
