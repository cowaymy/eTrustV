package com.coway.trust.biz.payment.reconciliation.service;

import java.io.Serializable;

import com.coway.trust.biz.sample.SampleDefaultVO;

public class CRCStatementVO implements Serializable {

	private static final long serialVersionUID = 1L;

	/**********************************
	 * Account Info
	 **********************************/
	private String accountType;		//

	
	/**********************************
	 * CRC Statement
	 **********************************/
	private String refNo = "";
	private String cardAccount = "";
	
	
	
	public String getAccountType() {
		return accountType;
	}

	public void setAccountType(String accountType) {
		this.accountType = accountType;
	}

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public String getCardAccount() {
		return cardAccount;
	}

	public void setCardAccount(String cardAccount) {
		this.cardAccount = cardAccount;
	}
	
	
	
	

}
