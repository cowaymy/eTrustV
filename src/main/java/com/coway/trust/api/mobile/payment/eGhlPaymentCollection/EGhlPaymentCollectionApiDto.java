package com.coway.trust.api.mobile.payment.eGhlPaymentCollection;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class EGhlPaymentCollectionApiDto {
	private List<EGhlPaymentCollectionApiDto> list;

	//Search Order Result
	private int salesOrdId;
	private String salesOrdNo;
	private Double productOutstandingAmount;
	private int productTypeId;
	private String productTypeName;
	private String productTypeCode;
	private Double membershipOutstandingAmount;
	private String membership;
	private int custId;
	private String nric;
	private String email;
	private String telNo;
	private int productId;
	private String productCode;
	private String productName;

	//Running number
	private String paymentCollectionRunningNumber;

	//Result
	private int responseCode;

	@SuppressWarnings("unchecked")
	public static EGhlPaymentCollectionApiDto create(EgovMap egovMap){
	 return BeanConverter.toBean(egovMap, EGhlPaymentCollectionApiDto.class);
	}

	public static Map<String, Object> createMap(EGhlPaymentCollectionApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("list", vo.getList());

		params.put("salesOrdId",vo.getSalesOrdId());
		params.put("salesOrdNo",vo.getSalesOrdNo());
		params.put("productOutstandingAmount",vo.getProductOutstandingAmount());
		params.put("productTypeId",vo.getProductTypeId());
		params.put("productTypeName",vo.getProductTypeName());
		params.put("productTypeCode",vo.getProductTypeCode());
		params.put("membershipOutstandingAmount",vo.getMembershipOutstandingAmount());
		params.put("membership",vo.getMembership());
		params.put("custId",vo.getCustId());
		params.put("nric",vo.getNric());
		params.put("email",vo.getEmail());
		params.put("telNo",vo.getTelNo());
		params.put("productId",vo.getProductId());
		params.put("productCode",vo.getProductCode());
		params.put("productName",vo.getProductName());

		params.put("paymentCollectionRunningNumber",vo.getPaymentCollectionRunningNumber());

		params.put("responseCode", vo.getResponseCode());
		return params;
	}

	public List<EGhlPaymentCollectionApiDto> getList() {
		return list;
	}

	public void setList(List<EGhlPaymentCollectionApiDto> list) {
		this.list = list;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public Double getProductOutstandingAmount() {
		return productOutstandingAmount;
	}

	public void setProductOutstandingAmount(Double productOutstandingAmount) {
		this.productOutstandingAmount = productOutstandingAmount;
	}

	public int getProductTypeId() {
		return productTypeId;
	}

	public void setProductTypeId(int productTypeId) {
		this.productTypeId = productTypeId;
	}

	public String getProductTypeName() {
		return productTypeName;
	}

	public void setProductTypeName(String productTypeName) {
		this.productTypeName = productTypeName;
	}

	public Double getMembershipOutstandingAmount() {
		return membershipOutstandingAmount;
	}

	public void setMembershipOutstandingAmount(Double membershipOutstandingAmount) {
		this.membershipOutstandingAmount = membershipOutstandingAmount;
	}

	public String getMembership() {
		return membership;
	}

	public void setMembership(String membership) {
		this.membership = membership;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getNric() {
		return nric;
	}

	public void setNric(String nric) {
		this.nric = nric;
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

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
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

	public int getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(int responseCode) {
		this.responseCode = responseCode;
	}

	public String getProductTypeCode() {
		return productTypeCode;
	}

	public void setProductTypeCode(String productTypeCode) {
		this.productTypeCode = productTypeCode;
	}

	public String getPaymentCollectionRunningNumber() {
		return paymentCollectionRunningNumber;
	}

	public void setPaymentCollectionRunningNumber(String paymentCollectionRunningNumber) {
		this.paymentCollectionRunningNumber = paymentCollectionRunningNumber;
	}
}
