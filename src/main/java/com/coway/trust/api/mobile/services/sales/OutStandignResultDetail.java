package com.coway.trust.api.mobile.services.sales;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModelProperty;

public class OutStandignResultDetail implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@ApiModelProperty(value = "Type 값")
	private String type;
	
	@ApiModelProperty(value = "DOCUMENT NO")
	private String docNo;
	
	@ApiModelProperty(value = "balance 금액 상세")
	private int balanceAmt = 0;
	
	@ApiModelProperty(value = "debit card 금액 상세")
	private int debitAmt = 0;
	
	@ApiModelProperty(value = "credit card 금액 상세")
	private int creditAmt = 0;
	
	@ApiModelProperty(value = "installAmt")
	private int installAmt = 0;
	
	@ApiModelProperty(value = "발생 날짜(YYYYMMDD)")
	private String eventDate;

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDocNo() {
		return docNo;
	}

	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}

	public int getBalanceAmt() {
		return balanceAmt;
	}

	public void setBalanceAmt(int balanceAmt) {
		this.balanceAmt = balanceAmt;
	}

	public int getDebitAmt() {
		return debitAmt;
	}

	public void setDebitAmt(int debitAmt) {
		this.debitAmt = debitAmt;
	}

	public int getCreditAmt() {
		return creditAmt;
	}

	public void setCreditAmt(int creditAmt) {
		this.creditAmt = creditAmt;
	}

	public int getInstallAmt() {
		return installAmt;
	}

	public void setInstallAmt(int installAmt) {
		this.installAmt = installAmt;
	}

	public String getEventDate() {
		return eventDate;
	}

	public void setEventDate(String eventDate) {
		this.eventDate = eventDate;
	}
	
	public static OutStandignResultDetail create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, OutStandignResultDetail.class);
	}
}
