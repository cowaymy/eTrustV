package com.coway.trust.biz.payment.payment.service;

public class PaymentDetailViewVO {
	private String defaultDate = "01/01/1900";
	
	private int payItemId;
	private int payId;
	private int modeId;
	private String modeName;
	private String refNo;
	
	private String cCNo;
	private String oriCCNo;
	private byte[] encryptedCCNo;
	private String encryptedCardNo;
	private int cCTypeId;
	private String cCTypeName;
	private String cCHolderName;
	private String cCExpiryDate;
	
	private String chqNo;
	private int issueBankId;
	private String issueBankCode;
	private String issueBankName;
	private double amount;
	private boolean isOnline;
	private int bankAccId;
	private String bankAccCode;
	private String bankAccName;
	private String refDate;
	private String approvalNo;
	private String remark;
	private int statusId;
	private String statusName;
	private boolean isLock;
	
	private double bankChargeAmount;
	private boolean isThirdParty;
	private String thirdPartyIc;
	
	private String mId;
	private int groupId;
	private int refItemId;
	private int eTC3;
	
	private String eFTNo;
	private String runningNo;
	
	private int cardTypeId;
	private String cardType;
	private String cRCModeType;
	public String getDefaultDate() {
		return defaultDate;
	}
	public void setDefaultDate(String defaultDate) {
		this.defaultDate = defaultDate;
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
	public int getModeId() {
		return modeId;
	}
	public void setModeId(int modeId) {
		this.modeId = modeId;
	}
	public String getModeName() {
		return modeName;
	}
	public void setModeName(String modeName) {
		this.modeName = modeName;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	public String getcCNo() {
		return cCNo;
	}
	public void setcCNo(String cCNo) {
		this.cCNo = cCNo;
	}
	public String getOriCCNo() {
		return oriCCNo;
	}
	public void setOriCCNo(String oriCCNo) {
		this.oriCCNo = oriCCNo;
	}
	public byte[] getEncryptedCCNo() {
		return encryptedCCNo;
	}
	public void setEncryptedCCNo(byte[] encryptedCCNo) {
		this.encryptedCCNo = encryptedCCNo;
	}
	public String getEncryptedCardNo() {
		return encryptedCardNo;
	}
	public void setEncryptedCardNo(String encryptedCardNo) {
		this.encryptedCardNo = encryptedCardNo;
	}
	public int getcCTypeId() {
		return cCTypeId;
	}
	public void setcCTypeId(int cCTypeId) {
		this.cCTypeId = cCTypeId;
	}
	public String getcCTypeName() {
		return cCTypeName;
	}
	public void setcCTypeName(String cCTypeName) {
		this.cCTypeName = cCTypeName;
	}
	public String getcCHolderName() {
		return cCHolderName;
	}
	public void setcCHolderName(String cCHolderName) {
		this.cCHolderName = cCHolderName;
	}
	public String getcCExpiryDate() {
		return cCExpiryDate;
	}
	public void setcCExpiryDate(String cCExpiryDate) {
		this.cCExpiryDate = cCExpiryDate;
	}
	public String getChqNo() {
		return chqNo;
	}
	public void setChqNo(String chqNo) {
		this.chqNo = chqNo;
	}
	public int getIssueBankId() {
		return issueBankId;
	}
	public void setIssueBankId(int issueBankId) {
		this.issueBankId = issueBankId;
	}
	public String getIssueBankCode() {
		return issueBankCode;
	}
	public void setIssueBankCode(String issueBankCode) {
		this.issueBankCode = issueBankCode;
	}
	public String getIssueBankName() {
		return issueBankName;
	}
	public void setIssueBankName(String issueBankName) {
		this.issueBankName = issueBankName;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public boolean isOnline() {
		return isOnline;
	}
	public void setOnline(boolean isOnline) {
		this.isOnline = isOnline;
	}
	public int getBankAccId() {
		return bankAccId;
	}
	public void setBankAccId(int bankAccId) {
		this.bankAccId = bankAccId;
	}
	public String getBankAccCode() {
		return bankAccCode;
	}
	public void setBankAccCode(String bankAccCode) {
		this.bankAccCode = bankAccCode;
	}
	public String getBankAccName() {
		return bankAccName;
	}
	public void setBankAccName(String bankAccName) {
		this.bankAccName = bankAccName;
	}
	public String getRefDate() {
		return refDate;
	}
	public void setRefDate(String refDate) {
		this.refDate = refDate;
	}
	public String getApprovalNo() {
		return approvalNo;
	}
	public void setApprovalNo(String approvalNo) {
		this.approvalNo = approvalNo;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getStatusId() {
		return statusId;
	}
	public void setStatusId(int statusId) {
		this.statusId = statusId;
	}
	public String getStatusName() {
		return statusName;
	}
	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}
	public boolean isLock() {
		return isLock;
	}
	public void setLock(boolean isLock) {
		this.isLock = isLock;
	}
	public double getBankChargeAmount() {
		return bankChargeAmount;
	}
	public void setBankChargeAmount(double bankChargeAmount) {
		this.bankChargeAmount = bankChargeAmount;
	}
	public boolean isThirdParty() {
		return isThirdParty;
	}
	public void setThirdParty(boolean isThirdParty) {
		this.isThirdParty = isThirdParty;
	}
	public String getThirdPartyIc() {
		return thirdPartyIc;
	}
	public void setThirdPartyIc(String thirdPartyIc) {
		this.thirdPartyIc = thirdPartyIc;
	}
	public String getmId() {
		return mId;
	}
	public void setmId(String mId) {
		this.mId = mId;
	}
	public int getGroupId() {
		return groupId;
	}
	public void setGroupId(int groupId) {
		this.groupId = groupId;
	}
	public int getRefItemId() {
		return refItemId;
	}
	public void setRefItemId(int refItemId) {
		this.refItemId = refItemId;
	}
	public int geteTC3() {
		return eTC3;
	}
	public void seteTC3(int eTC3) {
		this.eTC3 = eTC3;
	}
	public String geteFTNo() {
		return eFTNo;
	}
	public void seteFTNo(String eFTNo) {
		this.eFTNo = eFTNo;
	}
	public String getRunningNo() {
		return runningNo;
	}
	public void setRunningNo(String runningNo) {
		this.runningNo = runningNo;
	}
	public int getCardTypeId() {
		return cardTypeId;
	}
	public void setCardTypeId(int cardTypeId) {
		this.cardTypeId = cardTypeId;
	}
	public String getCardType() {
		return cardType;
	}
	public void setCardType(String cardType) {
		this.cardType = cardType;
	}
	public String getcRCModeType() {
		return cRCModeType;
	}
	public void setcRCModeType(String cRCModeType) {
		this.cRCModeType = cRCModeType;
	}
}	
