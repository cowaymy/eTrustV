package com.coway.trust.biz.payment.payment.service;

import java.util.Date;

public class PayDVO {
	private int payItemId;
	private int payId;
	private int payItemModeId;
	private String payItemRefNo;
	private String payItemCCNo;
	private String payItemOriCCNo;
	private byte[] payItemEncryptedCCNo;
	private int payItemCCTypeId;
	private String payItemChqNo;
	private int payItemIssuedBankId;
	private double payItemAmt;
	private boolean payItemIsOnline;
	private int payItemBankAccId;
	private String payItemRefDate;
	private String payItemAppvNo;
	private String payItemRemark;
	private int payItemStatusId;
	private boolean payItemIsLock;
	private String payItemCCHolderName;
	private String payItemCCExpiryDate;
	private double payItemBankChargeAmt;
	private boolean payItemIsThirdParty;
	private String payItemThirdPartyIC;
	private String payItemBankBranchId;
	private String payItemBankInSlipNo;
	private String payItemEFTNo;
	private String payItemCHQDepReceiptNo;
	private int ETC1;
	private int ETC2;
	private int ETC3;
	private String payItemMID;
	private int payItemGroupId;
	private int payItemRefItemId;
	private int payItemBankChargeAccId;
	private String payItemRunningNo;
	private int updator;
	private String updated;
	private boolean isFundTransfer;
	private boolean skipRecon;
	private int payItemCardTypeId;
	private int payItemCardModeId;
	
	
	public String getPayItemEFTNo() {
		return payItemEFTNo;
	}
	public void setPayItemEFTNo(String payItemEFTNo) {
		this.payItemEFTNo = payItemEFTNo;
	}
	public int getPayItemId() {
		return payItemId;
	}
	public void setPayItemId(int payItemId) {
		this.payItemId = payItemId;
	}
	public int getPayId() {
		return payId;
	}
	public void setPayId(int payId) {
		this.payId = payId;
	}
	public int getPayItemModeId() {
		return payItemModeId;
	}
	public void setPayItemModeId(int payItemModeId) {
		this.payItemModeId = payItemModeId;
	}
	public String getPayItemRefNo() {
		return payItemRefNo;
	}
	public void setPayItemRefNo(String payItemRefNo) {
		this.payItemRefNo = payItemRefNo;
	}
	public String getPayItemCCNo() {
		return payItemCCNo;
	}
	public void setPayItemCCNo(String payItemCCNo) {
		this.payItemCCNo = payItemCCNo;
	}
	public String getPayItemOriCCNo() {
		return payItemOriCCNo;
	}
	public void setPayItemOriCCNo(String payItemOriCCNo) {
		this.payItemOriCCNo = payItemOriCCNo;
	}
	public byte[] getPayItemEncryptedCCNo() {
		return payItemEncryptedCCNo;
	}
	public void setPayItemEncryptedCCNo(byte[] payItemEncryptedCCNo) {
		this.payItemEncryptedCCNo = payItemEncryptedCCNo;
	}
	public int getPayItemCCTypeId() {
		return payItemCCTypeId;
	}
	public void setPayItemCCTypeId(int payItemCCTypeId) {
		this.payItemCCTypeId = payItemCCTypeId;
	}
	public String getPayItemChqNo() {
		return payItemChqNo;
	}
	public void setPayItemChqNo(String payItemChqNo) {
		this.payItemChqNo = payItemChqNo;
	}
	public int getPayItemIssuedBankId() {
		return payItemIssuedBankId;
	}
	public void setPayItemIssuedBankId(int payItemIssuedBankId) {
		this.payItemIssuedBankId = payItemIssuedBankId;
	}
	public double getPayItemAmt() {
		return payItemAmt;
	}
	public void setPayItemAmt(double payItemAmt) {
		this.payItemAmt = payItemAmt;
	}
	public boolean isPayItemIsOnline() {
		return payItemIsOnline;
	}
	public void setPayItemIsOnline(boolean payItemIsOnline) {
		this.payItemIsOnline = payItemIsOnline;
	}
	public int getPayItemBankAccId() {
		return payItemBankAccId;
	}
	public void setPayItemBankAccId(int payItemBankAccId) {
		this.payItemBankAccId = payItemBankAccId;
	}
	public String getPayItemRefDate() {
		return payItemRefDate;
	}
	public void setPayItemRefDate(String payItemRefDate) {
		this.payItemRefDate = payItemRefDate;
	}
	public String getPayItemAppvNo() {
		return payItemAppvNo;
	}
	public void setPayItemAppvNo(String payItemAppvNo) {
		this.payItemAppvNo = payItemAppvNo;
	}
	public String getPayItemRemark() {
		return payItemRemark;
	}
	public void setPayItemRemark(String payItemRemark) {
		this.payItemRemark = payItemRemark;
	}
	public int getPayItemStatusId() {
		return payItemStatusId;
	}
	public void setPayItemStatusId(int payItemStatusId) {
		this.payItemStatusId = payItemStatusId;
	}
	public boolean isPayItemIsLock() {
		return payItemIsLock;
	}
	public void setPayItemIsLock(boolean payItemIsLock) {
		this.payItemIsLock = payItemIsLock;
	}
	public String getPayItemCCHolderName() {
		return payItemCCHolderName;
	}
	public void setPayItemCCHolderName(String payItemCCHolderName) {
		this.payItemCCHolderName = payItemCCHolderName;
	}
	public String getPayItemCCExpiryDate() {
		return payItemCCExpiryDate;
	}
	public void setPayItemCCExpiryDate(String payItemCCExpiryDate) {
		this.payItemCCExpiryDate = payItemCCExpiryDate;
	}
	public double getPayItemBankChargeAmt() {
		return payItemBankChargeAmt;
	}
	public void setPayItemBankChargeAmt(double payItemBankChargeAmt) {
		this.payItemBankChargeAmt = payItemBankChargeAmt;
	}
	public boolean isPayItemIsThirdParty() {
		return payItemIsThirdParty;
	}
	public void setPayItemIsThirdParty(boolean payItemIsThirdParty) {
		this.payItemIsThirdParty = payItemIsThirdParty;
	}
	public String getPayItemThirdPartyIC() {
		return payItemThirdPartyIC;
	}
	public void setPayItemThirdPartyIC(String payItemThirdPartyIC) {
		this.payItemThirdPartyIC = payItemThirdPartyIC;
	}
	public String getPayItemBankBranchId() {
		return payItemBankBranchId;
	}
	public void setPayItemBankBranchId(String payItemBankBranchId) {
		this.payItemBankBranchId = payItemBankBranchId;
	}
	public String getPayItemBankInSlipNo() {
		return payItemBankInSlipNo;
	}
	public void setPayItemBankInSlipNo(String payItemBankInSlipNo) {
		this.payItemBankInSlipNo = payItemBankInSlipNo;
	}
	public String getPayItemCHQDepReceiptNo() {
		return payItemCHQDepReceiptNo;
	}
	public void setPayItemCHQDepReceiptNo(String payItemCHQDepReceiptNo) {
		this.payItemCHQDepReceiptNo = payItemCHQDepReceiptNo;
	}
	public int getETC1() {
		return ETC1;
	}
	public void setETC1(int eTC1) {
		ETC1 = eTC1;
	}
	public int getETC2() {
		return ETC2;
	}
	public void setETC2(int eTC2) {
		ETC2 = eTC2;
	}
	public int getETC3() {
		return ETC3;
	}
	public void setETC3(int eTC3) {
		ETC3 = eTC3;
	}
	public String getPayItemMID() {
		return payItemMID;
	}
	public void setPayItemMID(String payItemMID) {
		this.payItemMID = payItemMID;
	}
	public int getPayItemGroupId() {
		return payItemGroupId;
	}
	public void setPayItemGroupId(int payItemGroupId) {
		this.payItemGroupId = payItemGroupId;
	}
	public int getPayItemRefItemId() {
		return payItemRefItemId;
	}
	public void setPayItemRefItemId(int payItemRefItemId) {
		this.payItemRefItemId = payItemRefItemId;
	}
	public int getPayItemBankChargeAccId() {
		return payItemBankChargeAccId;
	}
	public void setPayItemBankChargeAccId(int payItemBankChargeAccId) {
		this.payItemBankChargeAccId = payItemBankChargeAccId;
	}
	public String getPayItemRunningNo() {
		return payItemRunningNo;
	}
	public void setPayItemRunningNo(String payItemRunningNo) {
		this.payItemRunningNo = payItemRunningNo;
	}
	public int getUpdator() {
		return updator;
	}
	public void setUpdator(int updator) {
		this.updator = updator;
	}
	public String getUpdated() {
		return updated;
	}
	public void setUpdated(String updated) {
		this.updated = updated;
	}
	public boolean isFundTransfer() {
		return isFundTransfer;
	}
	public void setFundTransfer(boolean isFundTransfer) {
		this.isFundTransfer = isFundTransfer;
	}
	public boolean isSkipRecon() {
		return skipRecon;
	}
	public void setSkipRecon(boolean skipRecon) {
		this.skipRecon = skipRecon;
	}
	public int getPayItemCardTypeId() {
		return payItemCardTypeId;
	}
	public void setPayItemCardTypeId(int payItemCardTypeId) {
		this.payItemCardTypeId = payItemCardTypeId;
	}
	public int getPayItemCardModeId() {
		return payItemCardModeId;
	}
	public void setPayItemCardModeId(int payItemCardModeId) {
		this.payItemCardModeId = payItemCardModeId;
	}
}
