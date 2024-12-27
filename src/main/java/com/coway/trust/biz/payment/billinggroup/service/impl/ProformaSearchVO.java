package com.coway.trust.biz.payment.billinggroup.service.impl;

import java.util.Arrays;

public class ProformaSearchVO {
	private String orderNo;
	private String appType[];
	private String orderDt1;
	private String orderDt2;
	private String orderStatus[];
	private String keyBranch[];
	private String dscBranch[];
	private String custId;
	private String custName;
	private String custIc;
	private String product;
	private String memberCode;
	private String rentalStatus[];
	private String refNo;
	private String poNo;
	private String contactNo;
	private String memCode;
	private String orgCode;
	private String grpCode;
	private String deptCode;
	
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String[] getAppType() {
		return appType;
	}
	public void setAppType(String[] appType) {
		this.appType = appType;
	}
	public String getOrderDt1() {
		return orderDt1;
	}
	public void setOrderDt1(String orderDt1) {
		this.orderDt1 = orderDt1;
	}
	public String getOrderDt2() {
		return orderDt2;
	}
	public void setOrderDt2(String orderDt2) {
		this.orderDt2 = orderDt2;
	}
	public String[] getOrderStatus() {
		return orderStatus;
	}
	public void setOrderStatus(String[] orderStatus) {
		this.orderStatus = orderStatus;
	}
	public String[] getKeyBranch() {
		return keyBranch;
	}
	public void setKeyBranch(String[] keyBranch) {
		this.keyBranch = keyBranch;
	}
	public String[] getDscBranch() {
		return dscBranch;
	}
	public void setDscBranch(String[] dscBranch) {
		this.dscBranch = dscBranch;
	}
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public String getCustIc() {
		return custIc;
	}
	public void setCustIc(String custIc) {
		this.custIc = custIc;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public String getMemberCode() {
		return memberCode;
	}
	public void setMemberCode(String memberCode) {
		this.memberCode = memberCode;
	}
	public String[] getRentalStatus() {
		return rentalStatus;
	}
	public void setRentalStatus(String[] rentalStatus) {
		this.rentalStatus = rentalStatus;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	public String getPoNo() {
		return poNo;
	}
	public void setPoNo(String poNo) {
		this.poNo = poNo;
	}
	public String getContactNo() {
		return contactNo;
	}
	public void setContactNo(String contactNo) {
		this.contactNo = contactNo;
	}
	
	@Override
	public String toString() {
		return "ProformaSerchVO [orderNo=" + orderNo + ", appType=" + Arrays.toString(appType) + ", orderDt1="
				+ orderDt1 + ", orderDt2=" + orderDt2 + ", orderStatus=" + Arrays.toString(orderStatus) + ", keyBranch="
				+ Arrays.toString(keyBranch) + ", dscBranch=" + Arrays.toString(dscBranch) + ", custId=" + custId
				+ ", custName=" + custName + ", custIc=" + custIc + ", product=" + product + ", memberCode=" + memberCode
				+ ", rentalStatus=" + Arrays.toString(rentalStatus) + ", refNo=" + refNo + ", poNo=" + poNo
				+ ", contactNo=" + contactNo + "]";
	}
	public String getMemCode() {
		return memCode;
	}
	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public String getGrpCode() {
		return grpCode;
	}
	public void setGrpCode(String grpCode) {
		this.grpCode = grpCode;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	
	
	
}
