package com.coway.trust.biz.payment.reconciliation.service;

import java.util.Arrays;

public class ReconciliationSearchVO {
	private String tranNo;
	private String bankAccount;
	private String branchList;
	private String paymentDate1;
	private String paymentDate2;
	private String[] status;
	
	public String getTranNo() {
		return tranNo;
	}
	public void setTranNo(String tranNo) {
		this.tranNo = tranNo;
	}
	public String getBankAccount() {
		return bankAccount;
	}
	public void setBankAccount(String bankAccount) {
		this.bankAccount = bankAccount;
	}
	public String getBranchList() {
		return branchList;
	}
	public void setBranchList(String branchList) {
		this.branchList = branchList;
	}
	public String getPaymentDate1() {
		return paymentDate1;
	}
	public void setPaymentDate1(String paymentDate1) {
		this.paymentDate1 = paymentDate1;
	}
	public String getPaymentDate2() {
		return paymentDate2;
	}
	public void setPaymentDate2(String paymentDate2) {
		this.paymentDate2 = paymentDate2;
	}
	public String[] getStatus() {
		return status;
	}
	public void setStatus(String[] status) {
		this.status = status;
	}
	
}
