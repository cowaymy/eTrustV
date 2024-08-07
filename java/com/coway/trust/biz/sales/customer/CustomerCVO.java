package com.coway.trust.biz.sales.customer;

import java.io.Serializable;
import java.sql.Clob;
import java.util.Date;

public class CustomerCVO implements Serializable {

	private static final long serialVersionUID = -9093717560087654282L;

	private int crcType;						// Customer ID
	private int bank;								// Customer ID
//	private int creditCardNo;					// Customer ID
	private String cardType;
	private String cardRem;
	private int getCustCrcIdSeq;
	private int getCustId;
	private String crcNo;
	private String creditCardNo;
	private String encCrcNo;
	private String nmCard;
	private int crcStusId;
	private int crcUpdId;
	private int crcCrtId;
	private String cardExpiry;
	private int crcIdOld;
	private int soId;
	private int crcIdcm;
	private String crcToken;
	private String tokenRefNo;

	public int getCrcType() {
		return crcType;
	}
	public void setCrcType(int crcType) {
		this.crcType = crcType;
	}
	public int getBank() {
		return bank;
	}
	public void setBank(int bank) {
		this.bank = bank;
	}
	public String getCardType() {
		return cardType;
	}
	public void setCardType(String cardType) {
		this.cardType = cardType;
	}
	public String getCardRem() {
		return cardRem;
	}
	public void setCardRem(String cardRem) {
		this.cardRem = cardRem;
	}
	public int getGetCustCrcIdSeq() {
		return getCustCrcIdSeq;
	}
	public void setGetCustCrcIdSeq(int getCustCrcIdSeq) {
		this.getCustCrcIdSeq = getCustCrcIdSeq;
	}
	public int getGetCustId() {
		return getCustId;
	}
	public void setGetCustId(int getCustId) {
		this.getCustId = getCustId;
	}
	public String getCrcNo() {
		return crcNo;
	}
	public void setCrcNo(String crcNo) {
		this.crcNo = crcNo;
	}
	public String getCreditCardNo() {
		return creditCardNo;
	}
	public void setCreditCardNo(String creditCardNo) {
		this.creditCardNo = creditCardNo;
	}
	public String getEncCrcNo() {
		return encCrcNo;
	}
	public void setEncCrcNo(String encCrcNo) {
		this.encCrcNo = encCrcNo;
	}
	public String getNmCard() {
		return nmCard;
	}
	public void setNmCard(String nmCard) {
		this.nmCard = nmCard;
	}
	public int getCrcStusId() {
		return crcStusId;
	}
	public void setCrcStusId(int crcStusId) {
		this.crcStusId = crcStusId;
	}
	public int getCrcUpdId() {
		return crcUpdId;
	}
	public void setCrcUpdId(int crcUpdId) {
		this.crcUpdId = crcUpdId;
	}
	public int getCrcCrtId() {
		return crcCrtId;
	}
	public void setCrcCrtId(int crcCrtId) {
		this.crcCrtId = crcCrtId;
	}
	public String getCardExpiry() {
		return cardExpiry;
	}
	public void setCardExpiry(String cardExpiry) {
		this.cardExpiry = cardExpiry;
	}
	public int getCrcIdOld() {
		return crcIdOld;
	}
	public void setCrcIdOld(int crcIdOld) {
		this.crcIdOld = crcIdOld;
	}
	public int getSoId() {
		return soId;
	}
	public void setSoId(int soId) {
		this.soId = soId;
	}
	public int getCrcIdcm() {
		return crcIdcm;
	}
	public void setCrcIdcm(int crcIdcm) {
		this.crcIdcm = crcIdcm;
	}
	// LaiKW 2019-08-01 Tokenization - Start
	public void setCrcToken(String crcToken) {
	    this.crcToken = crcToken;
	}
	public String getCrcToken() {
	    return crcToken;
	}
	// LaiKW 2019-08-01 Tokenization - End

	// LaiKW 2020-03-10 MC Payment Tokenization - Start
    public String getTokenRefNo() {
        return tokenRefNo;
    }
    public void setTokenRefNo(String tokenRefNo) {
        this.tokenRefNo = tokenRefNo;
    }
    // LaiKW 2020-03-10 MC Payment Tokenization - End
}
