package com.coway.trust.biz.payment.reconciliation.service;

import java.io.Serializable;

public class ReconciliationListVO implements Serializable {
	private String reconciliationID;
	private String reconciliationNo;
	private String depositID;
	private String depositAccountID;
	private String depositAccountCode;
	private String depositPaymentDate;
	private String depositBranchID;
	private String depositBranchCode;
	private String depositAccountDesc;
	private String reconciliationStatusID;
	private String reconciliationStatus;
	private String reconciliationRemark;
	private String reconciliationCreated;
	private String reconciliationCreatorID;
	private String reconciliationCreatorName;
	private String reconciliationApproveAt;
	private String reconciliationApproverID;
	private String reconciliationApproverName;
	
	public String getDepositAccountCode() {
		return depositAccountCode;
	}
	public void setDepositAccountCode(String depositAccountCode) {
		this.depositAccountCode = depositAccountCode;
	}
	public String getReconciliationID() {
		return reconciliationID;
	}
	public void setReconciliationID(String reconciliationID) {
		this.reconciliationID = reconciliationID;
	}
	public String getReconciliationNo() {
		return reconciliationNo;
	}
	public void setReconciliationNo(String reconciliationNo) {
		this.reconciliationNo = reconciliationNo;
	}
	public String getDepositID() {
		return depositID;
	}
	public void setDepositID(String depositID) {
		this.depositID = depositID;
	}
	public String getDepositAccountID() {
		return depositAccountID;
	}
	public void setDepositAccountID(String depositAccountID) {
		this.depositAccountID = depositAccountID;
	}
	public String getDepositPaymentDate() {
		return depositPaymentDate;
	}
	public void setDepositPaymentDate(String depositPaymentDate) {
		this.depositPaymentDate = depositPaymentDate;
	}
	public String getDepositBranchID() {
		return depositBranchID;
	}
	public void setDepositBranchID(String depositBranchID) {
		this.depositBranchID = depositBranchID;
	}
	public String getDepositBranchCode() {
		return depositBranchCode;
	}
	public void setDepositBranchCode(String depositBranchCode) {
		this.depositBranchCode = depositBranchCode;
	}
	public String getDepositAccountDesc() {
		return depositAccountDesc;
	}
	public void setDepositAccountDesc(String depositAccountDesc) {
		this.depositAccountDesc = depositAccountDesc;
	}
	public String getReconciliationStatusID() {
		return reconciliationStatusID;
	}
	public void setReconciliationStatusID(String reconciliationStatusID) {
		this.reconciliationStatusID = reconciliationStatusID;
	}
	public String getReconciliationStatus() {
		return reconciliationStatus;
	}
	public void setReconciliationStatus(String reconciliationStatus) {
		this.reconciliationStatus = reconciliationStatus;
	}
	public String getReconciliationRemark() {
		return reconciliationRemark;
	}
	public void setReconciliationRemark(String reconciliationRemark) {
		this.reconciliationRemark = reconciliationRemark;
	}
	public String getReconciliationCreated() {
		return reconciliationCreated;
	}
	public void setReconciliationCreated(String reconciliationCreated) {
		this.reconciliationCreated = reconciliationCreated;
	}
	public String getReconciliationCreatorID() {
		return reconciliationCreatorID;
	}
	public void setReconciliationCreatorID(String reconciliationCreatorID) {
		this.reconciliationCreatorID = reconciliationCreatorID;
	}
	public String getReconciliationCreatorName() {
		return reconciliationCreatorName;
	}
	public void setReconciliationCreatorName(String reconciliationCreatorName) {
		this.reconciliationCreatorName = reconciliationCreatorName;
	}
	public String getReconciliationApproveAt() {
		return reconciliationApproveAt;
	}
	public void setReconciliationApproveAt(String reconciliationApproveAt) {
		this.reconciliationApproveAt = reconciliationApproveAt;
	}
	public String getReconciliationApproverID() {
		return reconciliationApproverID;
	}
	public void setReconciliationApproverID(String reconciliationApproverID) {
		this.reconciliationApproverID = reconciliationApproverID;
	}
	public String getReconciliationApproverName() {
		return reconciliationApproverName;
	}
	public void setReconciliationApproverName(String reconciliationApproverName) {
		this.reconciliationApproverName = reconciliationApproverName;
	}

}
