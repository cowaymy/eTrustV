package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class BatchPaymentVO {
  private String orderNo;
  private String trNo;
  private String refNo;
  private String amount;
  private String bankAcc;
  private String chqNo;
  private String issueBank;
  private String runningNo;
  private String eftNo;
  private String refDate_Month;
  private String refDate_Day;
  private String refDate_Year;
  private String bankChargeAmt;
  private String bankChargeAcc;
  private String trDate;
  private String collectorCode;
  private String paymentType;
  private String advanceMonth;
  private String userRemark;
  private String cardNo;
  private String approvalCode;
  private String cardMode;
  private String paymentChnnl;

  public static BatchPaymentVO create(CSVRecord CSVRecord) {
    BatchPaymentVO vo = new BatchPaymentVO();
    vo.setOrderNo(CSVRecord.get(0));
    vo.setTrNo(CSVRecord.get(1));
    vo.setRefNo(CSVRecord.get(2));
    vo.setAmount(CSVRecord.get(3));
    vo.setBankAcc(CSVRecord.get(4));
    vo.setChqNo(CSVRecord.get(5));
    vo.setIssueBank(CSVRecord.get(6));
    vo.setRunningNo(CSVRecord.get(7));
    vo.setEftNo(CSVRecord.get(8));
    vo.setRefDate_Month(CSVRecord.get(9));
    vo.setRefDate_Day(CSVRecord.get(10));
    vo.setRefDate_Year(CSVRecord.get(11));
    vo.setBankChargeAmt(CSVRecord.get(12));
    vo.setBankChargeAcc(CSVRecord.get(13));
    vo.setTrDate(CSVRecord.get(14));
    vo.setCollectorCode(CSVRecord.get(15));
    vo.setPaymentType(CSVRecord.get(16));
    vo.setAdvanceMonth(CSVRecord.get(17));
    vo.setUserRemark(CSVRecord.get(18));
    vo.setCardNo(CSVRecord.get(19));
    vo.setApprovalCode(CSVRecord.get(20));
    vo.setCardMode(CSVRecord.get(21));
    vo.setPaymentChnnl(CSVRecord.get(22));

    return vo;
  }

  public String getTrDate() {
    return trDate;
  }

  public void setTrDate(String trDate) {
    this.trDate = trDate;
  }

  public String getCollectorCode() {
    return collectorCode;
  }

  public void setCollectorCode(String collectorCode) {
    this.collectorCode = collectorCode;
  }

  public String getPaymentType() {
    return paymentType;
  }

  public void setPaymentType(String paymentType) {
    this.paymentType = paymentType;
  }

  public String getAdvanceMonth() {
    return advanceMonth;
  }

  public void setAdvanceMonth(String advanceMonth) {
    this.advanceMonth = advanceMonth;
  }

  public String getOrderNo() {
    return orderNo;
  }

  public void setOrderNo(String orderNo) {
    this.orderNo = orderNo;
  }

  public String getTrNo() {
    return trNo;
  }

  public void setTrNo(String trNo) {
    this.trNo = trNo;
  }

  public String getRefNo() {
    return refNo;
  }

  public void setRefNo(String refNo) {
    this.refNo = refNo;
  }

  public String getAmount() {
    return amount;
  }

  public void setAmount(String amount) {
    this.amount = amount;
  }

  public String getBankAcc() {
    return bankAcc;
  }

  public void setBankAcc(String bankAcc) {
    this.bankAcc = bankAcc;
  }

  public String getChqNo() {
    return chqNo;
  }

  public void setChqNo(String chqNo) {
    this.chqNo = chqNo;
  }

  public String getIssueBank() {
    return issueBank;
  }

  public void setIssueBank(String issueBank) {
    this.issueBank = issueBank;
  }

  public String getRunningNo() {
    return runningNo;
  }

  public void setRunningNo(String runningNo) {
    this.runningNo = runningNo;
  }

  public String getEftNo() {
    return eftNo;
  }

  public void setEftNo(String eftNo) {
    this.eftNo = eftNo;
  }

  public String getRefDate_Month() {
    return refDate_Month;
  }

  public void setRefDate_Month(String refDate_Month) {
    this.refDate_Month = refDate_Month;
  }

  public String getRefDate_Day() {
    return refDate_Day;
  }

  public void setRefDate_Day(String refDate_Day) {
    this.refDate_Day = refDate_Day;
  }

  public String getRefDate_Year() {
    return refDate_Year;
  }

  public void setRefDate_Year(String refDate_Year) {
    this.refDate_Year = refDate_Year;
  }

  public String getBankChargeAmt() {
    return bankChargeAmt;
  }

  public void setBankChargeAmt(String bankChargeAmt) {
    this.bankChargeAmt = bankChargeAmt;
  }

  public String getBankChargeAcc() {
    return bankChargeAcc;
  }

  public void setBankChargeAcc(String bankChargeAcc) {
    this.bankChargeAcc = bankChargeAcc;
  }

  public String getUserRemark() {
    return userRemark;
  }

  public void setUserRemark(String userRemark) {
    this.userRemark = userRemark;
  }

  public String getCardNo() {
    return cardNo;
  }

  public void setCardNo(String cardNo) {
    this.cardNo = cardNo;
  }

  public String getApprovalCode() {
    return approvalCode;
  }

  public void setApprovalCode(String approvalCode) {
    this.approvalCode = approvalCode;
  }

  public String getCardMode() {
    return cardMode;
  }

  public void setCardMode(String cardMode) {
    this.cardMode = cardMode;
  }

  public String getPaymentChnnl() {
    return paymentChnnl;
  }

  public void setPaymentChnnl(String paymentChnnl) {
    this.paymentChnnl = paymentChnnl;
  }

}
