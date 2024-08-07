package com.coway.trust.api.mobile.payment.cashMatching;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : CashMatchingForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 19.   KR-HAN        First creation
 * 2020. 08. 21.   MY-ONGHC    Add additional attachment
 * </pre>
 */
@ApiModel(value = "CashMatchingForm", description = "CashMatching Form")
public class CashMatchingForm {

  @ApiModelProperty(value = "fromDate", example = "1")
  private String fromDate;

  @ApiModelProperty(value = "toDate", example = "1")
  private String toDate;

  @ApiModelProperty(value = "userId", example = "1")
  private String userId;

  @ApiModelProperty(value = "mobPayNo", example = "1")
  private String mobPayNo;

  @ApiModelProperty(value = "salesOrdNo", example = "1")
  private String salesOrdNo;

  @ApiModelProperty(value = "slipNo", example = "1")
  private String slipNo;

  @ApiModelProperty(value = "uploadImg1", example = "1")
  private String uploadImg1;

  @ApiModelProperty(value = "uploadImg2", example = "1")
  private String uploadImg2;

  @ApiModelProperty(value = "uploadImg3", example = "1")
  private String uploadImg3;

  @ApiModelProperty(value = "uploadImg4", example = "1")
  private String uploadImg4;

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public String getFromDate() {
    return fromDate;
  }

  public void setFromDate(String fromDate) {
    this.fromDate = fromDate;
  }

  public String getToDate() {
    return toDate;
  }

  public void setToDate(String toDate) {
    this.toDate = toDate;
  }

  public String getMobPayNo() {
    return mobPayNo;
  }

  public void setMobPayNo(String mobPayNo) {
    this.mobPayNo = mobPayNo;
  }

  public String getSalesOrdNo() {
    return salesOrdNo;
  }

  public void setSalesOrdNo(String salesOrdNo) {
    this.salesOrdNo = salesOrdNo;
  }

  public String getSlipNo() {
    return slipNo;
  }

  public void setSlipNo(String slipNo) {
    this.slipNo = slipNo;
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

  public static Map<String, Object> createMap(CashMatchingForm cashMatchingForm) {
    Map<String, Object> params = new HashMap<>();

    params.put("fromDate", cashMatchingForm.getFromDate());
    params.put("toDate", cashMatchingForm.getToDate());
    params.put("userId", cashMatchingForm.getUserId());
    params.put("mobPayNo", cashMatchingForm.getMobPayNo());
    params.put("salesOrdNo", cashMatchingForm.getSalesOrdNo());
    params.put("slipNo", cashMatchingForm.getSlipNo());
    params.put("uploadImg1", cashMatchingForm.getUploadImg1());
    params.put("uploadImg2", cashMatchingForm.getUploadImg2());
    params.put("uploadImg3", cashMatchingForm.getUploadImg3());
    params.put("uploadImg4", cashMatchingForm.getUploadImg4());

    return params;
  }

}
