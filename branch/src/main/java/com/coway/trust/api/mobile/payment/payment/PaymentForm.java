package com.coway.trust.api.mobile.payment.payment;

import java.util.HashMap;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @History
 *
 *          <pre>
 * Date              Author       Description
 * -------------    -----------  -------------
 * 2020. 08. 12.  ONGHC      Add Additional Attachment Upload
 *          </pre>
 */

@ApiModel(value = "PaymentForm", description = "Payment Form")
public class PaymentForm {

	@ApiModelProperty(value = "userId 예)1 ", example = "1")
	private String userId;

	@ApiModelProperty(value = "searchType 예)1 ", example = "1")
	private String searchType;

	@ApiModelProperty(value = "searchKeyword 예)0030784", example = "0030784")
	private String searchKeyword;

	@ApiModelProperty(value = "salesOrdNo 예)2276627", example = "2276627")
	private String salesOrdNo;

	@ApiModelProperty(value = "orderId 예)1222667", example = "1222667")
	private String orderId;

  @ApiModelProperty(value = "payMode")
  private String payMode;

  @ApiModelProperty(value = "advMonth")
  private String advMonth;

  @ApiModelProperty(value = "advAmt")
  private String advAmt;

  @ApiModelProperty(value = "otstndAmt")
  private String otstndAmt;

  @ApiModelProperty(value = "payAmt")
  private String payAmt;

  @ApiModelProperty(value = "uploadImg1")
  private String uploadImg1;

  @ApiModelProperty(value = "uploadImg2")
  private String uploadImg2;

  @ApiModelProperty(value = "uploadImg3")
  private String uploadImg3;

  @ApiModelProperty(value = "uploadImg4")
  private String uploadImg4;

  @ApiModelProperty(value = "slipNo")
  private String slipNo;

  @ApiModelProperty(value = "issuBankId")
  private String issuBankId;

  @ApiModelProperty(value = "chequeDt")
  private String chequeDt;

  @ApiModelProperty(value = "chequeNo")
  private String chequeNo;

  @ApiModelProperty(value = "sms1")
  private String sms1;

  @ApiModelProperty(value = "sms2")
  private String sms2;

  @ApiModelProperty(value = "email1")
  private String email1;

  @ApiModelProperty(value = "email2")
  private String email2;

  @ApiModelProperty(value = "signImg")
  private String signImg;

  @ApiModelProperty(value = "payRem")
  private String payRem;

  @ApiModelProperty(value = "signData")
  private String signData;


  @ApiModelProperty(value = "cardNo")
  private String cardNo;

  @ApiModelProperty(value = "approvalNo")
  private String approvalNo;

  @ApiModelProperty(value = "crcName")
  private String crcName;

  @ApiModelProperty(value = "transactionDate")
  private String transactionDate;

  @ApiModelProperty(value = "expiryDate")
  private String expiryDate;

  @ApiModelProperty(value = "cardMode")
  private String cardMode;

  @ApiModelProperty(value = "merchantBank")
  private String merchantBank;

  @ApiModelProperty(value = "cardBrand")
  private String cardBrand;



  public String getPayMode() {
    return payMode;
  }

  public void setPayMode(String payMode) {
    this.payMode = payMode;
  }

  public String getAdvMonth() {
    return advMonth;
  }

  public void setAdvMonth(String advMonth) {
    this.advMonth = advMonth;
  }

  public String getAdvAmt() {
    return advAmt;
  }

  public void setAdvAmt(String advAmt) {
    this.advAmt = advAmt;
  }

  public String getOtstndAmt() {
    return otstndAmt;
  }

  public void setOtstndAmt(String otstndAmt) {
    this.otstndAmt = otstndAmt;
  }

  public String getPayAmt() {
   return payAmt;
	}

  public void setPayAmt(String payAmt) {
    this.payAmt = payAmt;
  }

  public String getUploadImg1() {
    return uploadImg1;
  }

  public void setUploadImg1(String uploadImg1) {
    this.uploadImg1 = uploadImg1;
  }

  public String getUploadImg2() {
    return uploadImg2;
  }

  public void setUploadImg2(String uploadImg2) {
    this.uploadImg2 = uploadImg2;
  }

  public String getUploadImg3() {
    return uploadImg3;
  }

  public void setUploadImg3(String uploadImg3) {
    this.uploadImg3 = uploadImg3;
  }


  public String getUploadImg4() {
    return uploadImg4;
  }

  public void setUploadImg4(String uploadImg4) {
    this.uploadImg4 = uploadImg4;
  }


  public String getSlipNo() {
    return slipNo;
  }

  public void setSlipNo(String slipNo) {
    this.slipNo = slipNo;
  }

  public String getIssuBankId() {
    return issuBankId;
  }

  public void setIssuBankId(String issuBankId) {
    this.issuBankId = issuBankId;
  }

  public String getChequeDt() {
    return chequeDt;
  }

  public void setChequeDt(String chequeDt) {
    this.chequeDt = chequeDt;
  }

  public String getChequeNo() {
    return chequeNo;
  }

  public void setChequeNo(String chequeNo) {
    this.chequeNo = chequeNo;
  }

  public String getSms1() {
    return sms1;
  }

  public void setSms1(String sms1) {
    this.sms1 = sms1;
  }

  public String getSms2() {
    return sms2;
  }

  public void setSms2(String sms2) {
    this.sms2 = sms2;
  }

  public String getEmail1() {
    return email1;
  }

  public void setEmail1(String email1) {
    this.email1 = email1;
  }

  public String getEmail2() {
    return email2;
  }

  public void setEmail2(String email2) {
    this.email2 = email2;
  }

  public String getSignImg() {
    return signImg;
  }

  public void setSignImg(String signImg) {
    this.signImg = signImg;
  }

  public String getPayRem() {
    return payRem;
  }

  public void setPayRem(String payRem) {
    this.payRem = payRem;
  }

  public String getOrderId() {
    return orderId;
  }

  public void setOrderId(String orderId) {
    this.orderId = orderId;
  }

  public String getSearchKeyword() {
    return searchKeyword;
  }

  public void setSearchKeyword(String searchKeyword) {
    this.searchKeyword = searchKeyword;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public String getSearchType() {
    return searchType;
  }

  public void setSearchType(String searchType) {
    this.searchType = searchType;
  }

  public String getSalesOrdNo() {
    return salesOrdNo;
  }

  public void setSalesOrdNo(String salesOrdNo) {
    this.salesOrdNo = salesOrdNo;
  }

  public String getSignData() {
    return signData;
  }

  public void setSignData(String signData) {
    this.signData = signData;
  }

  public String getCardNo() {
	return cardNo;
}

public void setCardNo(String cardNo) {
	this.cardNo = cardNo;
}

public String getApprovalNo() {
	return approvalNo;
}

public void setApprovalNo(String approvalNo) {
	this.approvalNo = approvalNo;
}

public String getCrcName() {
	return crcName;
}

public void setCrcName(String crcName) {
	this.crcName = crcName;
}

public String getTransactionDate() {
	return transactionDate;
}

public void setTransactionDate(String transactionDate) {
	this.transactionDate = transactionDate;
}

public String getExpiryDate() {
	return expiryDate;
}

public void setExpiryDate(String expiryDate) {
	this.expiryDate = expiryDate;
}

public String getCardMode() {
	return cardMode;
}

public void setCardMode(String cardMode) {
	this.cardMode = cardMode;
}

public String getMerchantBank() {
	return merchantBank;
}

public void setMerchantBank(String merchantBank) {
	this.merchantBank = merchantBank;
}

public String getCardBrand() {
	return cardBrand;
}

public void setCardBrand(String cardBrand) {
	this.cardBrand = cardBrand;
}


public static Map<String, Object> createMap(PaymentForm paymentForm){
    Map<String, Object> params = new HashMap<>();

    params.put("userId", paymentForm.getUserId());
    params.put("searchType", paymentForm.getSearchType());
    params.put("searchKeyword", 	paymentForm.getSearchKeyword());
    params.put("salesOrdNo", paymentForm.getSalesOrdNo());
    params.put("orderId", paymentForm.getOrderId());

    params.put("payMode", paymentForm.getPayMode());
    params.put("advMonth", paymentForm.getAdvMonth());
    params.put("advAmt", paymentForm.getAdvAmt());
    params.put("otstndAmt", paymentForm.getOtstndAmt());
    params.put("payAmt", paymentForm.getPayAmt());
    params.put("uploadImg1", paymentForm.getUploadImg1());
    params.put("uploadImg2", paymentForm.getUploadImg2());
    params.put("uploadImg3", paymentForm.getUploadImg3());
    params.put("uploadImg4", paymentForm.getUploadImg4());
    params.put("slipNo", paymentForm.getSlipNo());
    params.put("issuBankId", paymentForm.getIssuBankId());
    params.put("chequeDt", paymentForm.getChequeDt());
    params.put("chequeNo", paymentForm.getChequeNo());
    params.put("sms1", paymentForm.getSms1());
    params.put("sms2", paymentForm.getSms2());
    params.put("email1", paymentForm.getEmail1());
    params.put("email2", paymentForm.getEmail2());
    params.put("signImg", paymentForm.getSignImg());
    params.put("payRem", paymentForm.getPayRem());
    params.put("signData", paymentForm.getSignData());

    params.put("cardNo", paymentForm.getCardNo());
    params.put("approvalNo", paymentForm.getApprovalNo());
    params.put("crcName", paymentForm.getCrcName());
    params.put("transactionDate", paymentForm.getTransactionDate());
    params.put("expiryDate", paymentForm.getExpiryDate());
    params.put("cardMode", paymentForm.getCardMode());
    params.put("merchantBank", paymentForm.getMerchantBank());
    params.put("cardBrand", paymentForm.getCardBrand());

    return params;
  }
}
