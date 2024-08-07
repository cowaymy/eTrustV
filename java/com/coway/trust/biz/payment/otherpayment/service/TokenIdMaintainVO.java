package com.coway.trust.biz.payment.otherpayment.service;

import org.apache.commons.csv.CSVRecord;


public class TokenIdMaintainVO {
	private String tokenId;
	private String cardType;
	private String creditCardType;
	private String responseCode;
	private String responseDesc;
	private String remark;

	public String getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(String responseCode) {
		this.responseCode = responseCode;
	}

	public String getResponseDesc() {
		return responseDesc;
	}

	public void setResponseDesc(String responseDesc) {
		this.responseDesc = responseDesc;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getCardType() {
		return cardType;
	}

	public String getCreditCardType() {
		return creditCardType;
	}

	public void setCreditCardType(String creditCardType) {
		this.creditCardType = creditCardType;
	}

	public void setCardType(String cardType) {
		this.cardType = cardType;
	}

	public String getTokenId() {
		return tokenId;
	}

	public void setTokenId(String tokenId) {
		this.tokenId = tokenId;
	}

	public static TokenIdMaintainVO create(CSVRecord CSVRecord) {
		TokenIdMaintainVO vo = new TokenIdMaintainVO();
		vo.setTokenId(CSVRecord.get(0));
		vo.setCardType(CSVRecord.get(1));
		vo.setCreditCardType(CSVRecord.get(2));
		vo.setResponseCode(CSVRecord.get(3));
		vo.setResponseDesc(CSVRecord.get(4));
		vo.setRemark(CSVRecord.get(5));

		return vo;
	}


}
