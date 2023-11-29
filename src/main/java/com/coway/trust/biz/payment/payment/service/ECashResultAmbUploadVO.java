package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class ECashResultAmbUploadVO {
  private String respnsCode;
  private String appvCode;
  private String settleDate;
  private int itmId;
  private int itmCnt;

  public static ECashResultAmbUploadVO create(CSVRecord CSVRecord) {

    ECashResultAmbUploadVO vo = new ECashResultAmbUploadVO();

    vo.setItmId(Integer.parseInt(CSVRecord.get(0).substring(46,86).trim()));
    vo.setAppvCode(CSVRecord.get(0).substring(132,133).trim());
    vo.setRespnsCode(CSVRecord.get(0).substring(133,139).trim());
    vo.setItmCnt((int)CSVRecord.getRecordNumber());

    return vo;

  }

  public int getItmCnt() {
    return itmCnt;
  }

  public void setItmCnt(int itmCnt) {
    this.itmCnt = itmCnt;
  }

  public int getItmId() {
    return itmId;
  }

  public void setItmId(int itmId) {
    this.itmId = itmId;
  }

  public String getAppvCode() {
    return appvCode;
  }

  public void setAppvCode(String appvCode) {
    this.appvCode = appvCode;
  }

  public String getRespnsCode() {
    return respnsCode;
  }

  public void setRespnsCode(String respnsCode) {
    this.respnsCode = respnsCode;
  }

  public String getSettleDate() {
    return settleDate;
  }

  public void setSettleDate(String settleDate) {
    this.settleDate = settleDate;
  }


}
