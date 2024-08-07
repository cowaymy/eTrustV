package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class ClaimResultAmbUploadVO {

  private String refCode;
  private int itemId;
  private String apprCode;


  public static ClaimResultAmbUploadVO create(CSVRecord CSVRecord) {

    ClaimResultAmbUploadVO vo = new ClaimResultAmbUploadVO();

    vo.setItemId(Integer.parseInt(CSVRecord.get(0).substring(46,86).trim()));

    vo.setRefCode(CSVRecord.get(0).substring(133,139).trim());

    vo.setApprCode(CSVRecord.get(0).substring(132,133).trim());

    return vo;
  }

  public String getRefCode() {
    return refCode;
  }

  public void setRefCode(String refCode) {
    this.refCode = refCode;
  }

  public int getItemId() {
    return itemId;
  }

  public void setItemId(int itemId) {
    this.itemId = itemId;
  }

  public String getApprCode() {
      return apprCode;
  }

  public void setApprCode(String apprCode) {
    this.apprCode = apprCode;
  }

}
