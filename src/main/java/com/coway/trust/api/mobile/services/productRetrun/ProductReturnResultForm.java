package com.coway.trust.api.mobile.services.productRetrun;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ProductReturnResultForm", description = "공통코드 Form")
public class ProductReturnResultForm {
  @ApiModelProperty(value = "사용자 ID (예_CT123456)")
  private String userId;

  @ApiModelProperty(value = "주문번호")
  private String salesOrderNo;

  @ApiModelProperty(value = "EX_BS00000 / AS00000")
  private String serviceNo;

  @ApiModelProperty(value = "결과 등록 메모")
  private String resultRemark;

  @ApiModelProperty(value = "결과 등록시, Owner Code")
  private String ownerCode;

  @ApiModelProperty(value = "결과 등록시, Cust Name")
  private String resultCustName;

  @ApiModelProperty(value = "결과 등록시, NrIc 또는 Mobile No")
  private String resultIcMobileNo;

  @ApiModelProperty(value = "결과 등록시, Email_No")
  private String resultReportEmailNo;

  @ApiModelProperty(value = "결과 등록시, Acceptance Name")
  private String resultAcceptanceName;

  @ApiModelProperty(value = "base64 Data")
  private String signData;

  @ApiModelProperty(value = "Transaction ID 값(체계 : USER_ID + SALES_ORDER_NO + SERVICE_NO + 현재시간_YYYYMMDDHHMMSS)")
  private String transactionId;

  private String checkInDate;

  private String checkInTime;

  private String checkInGps;

  @ApiModelProperty(value = "signRegDate Data")
  private String signRegDate;

  @ApiModelProperty(value = "signRegTime Data")
  private String signRegTime;

  private String ccCode;

  private String resultCode;

  private String serialRequireChkYn;

  private String retnCodeFailRemark;

  private String partnerCode;

  private String partnerCodeName;

  public String getSerialRequireChkYn() {
    return serialRequireChkYn;
  }

  public void setSerialRequireChkYn( String serialRequireChkYn ) {
    this.serialRequireChkYn = serialRequireChkYn;
  }

  public String getCcCode() {
    return ccCode;
  }

  public void setCcCode( String ccCode ) {
    this.ccCode = ccCode;
  }

  public String getResultCode() {
    return resultCode;
  }

  public void setResultCode( String resultCode ) {
    this.resultCode = resultCode;
  }

  public String getSignRegDate() {
    return signRegDate;
  }

  public void setSignRegDate( String signRegDate ) {
    this.signRegDate = signRegDate;
  }

  public String getSignRegTime() {
    return signRegTime;
  }

  public void setSignRegTime( String signRegTime ) {
    this.signRegTime = signRegTime;
  }

  public String getCheckInDate() {
    return checkInDate;
  }

  public void setCheckInDate( String checkInDate ) {
    this.checkInDate = checkInDate;
  }

  public String getCheckInTime() {
    return checkInTime;
  }

  public void setCheckInTime( String checkInTime ) {
    this.checkInTime = checkInTime;
  }

  public String getCheckInGps() {
    return checkInGps;
  }

  public void setCheckInGps( String checkInGps ) {
    this.checkInGps = checkInGps;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId( String userId ) {
    this.userId = userId;
  }

  public String getSalesOrderNo() {
    return salesOrderNo;
  }

  public void setSalesOrderNo( String salesOrderNo ) {
    this.salesOrderNo = salesOrderNo;
  }

  public String getServiceNo() {
    return serviceNo;
  }

  public void setServiceNo( String serviceNo ) {
    this.serviceNo = serviceNo;
  }

  public String getResultRemark() {
    return resultRemark;
  }

  public void setResultRemark( String resultRemark ) {
    this.resultRemark = resultRemark;
  }

  public String getOwnerCode() {
    return ownerCode;
  }

  public void setOwnerCode( String ownerCode ) {
    this.ownerCode = ownerCode;
  }

  public String getResultCustName() {
    return resultCustName;
  }

  public void setResultCustName( String resultCustName ) {
    this.resultCustName = resultCustName;
  }

  public String getResultIcMobileNo() {
    return resultIcMobileNo;
  }

  public void setResultIcMobileNo( String resultIcMobileNo ) {
    this.resultIcMobileNo = resultIcMobileNo;
  }

  public String getResultReportEmailNo() {
    return resultReportEmailNo;
  }

  public void setResultReportEmailNo( String resultReportEmailNo ) {
    this.resultReportEmailNo = resultReportEmailNo;
  }

  public String getResultAcceptanceName() {
    return resultAcceptanceName;
  }

  public void setResultAcceptanceName( String resultAcceptanceName ) {
    this.resultAcceptanceName = resultAcceptanceName;
  }

  public String getSignData() {
    return signData;
  }

  public void setSignData( String signData ) {
    this.signData = signData;
  }

  public String getTransactionId() {
    return transactionId;
  }

  public void setTransactionId( String transactionId ) {
    this.transactionId = transactionId;
  }

  private String scanSerial;

  public String getScanSerial() {
    return scanSerial;
  }

  public void setScanSerial( String scanSerial ) {
    this.scanSerial = scanSerial;
  }

  private String fraSerialNo;

  public String getFraSerialNo() {
    return fraSerialNo;
  }

  public void setFraSerialNo( String fraSerialNo ) {
    this.fraSerialNo = fraSerialNo;
  }

  public String getRetnCodeFailRemark() {
    return retnCodeFailRemark;
  }

  public void setRetnCodeFailRemark( String retnCodeFailRemark ) {
    this.retnCodeFailRemark = retnCodeFailRemark;
  }

  public String getPartnerCode() {
    return partnerCode;
  }

  public void setPartnerCode( String partnerCode ) {
    this.partnerCode = partnerCode;
  }

  public String getPartnerCodeName() {
    return partnerCodeName;
  }

  public void setPartnerCodeName( String partnerCodeName ) {
    this.partnerCodeName = partnerCodeName;
  }

  public static List<Map<String, Object>> createMaps( ProductReturnResultForm productReturnResultForm ) {
    List<Map<String, Object>> list = new ArrayList<>();
    Map<String, Object> map;
    map = BeanConverter.toMap( productReturnResultForm, "signData" );
    map.put( "resultCode", productReturnResultForm.getResultCode() );
    map.put( "ccCode", productReturnResultForm.getCcCode() );
    map.put( "signData", Base64.decodeBase64( productReturnResultForm.getSignData() ) );
    //map.put("signData",    productReturnResultForm.getSignData());
    map.put( "checkinDt", productReturnResultForm.getCheckInDate() );
    map.put( "checkinTm", productReturnResultForm.getCheckInTime() );
    map.put( "checkinGps", productReturnResultForm.getCheckInGps() );
    map.put( "signRegDt", productReturnResultForm.getSignRegDate() );
    map.put( "signRegTm", productReturnResultForm.getSignRegTime() );
    map.put( "userId", productReturnResultForm.getUserId() );
    map.put( "salesOrderNo", productReturnResultForm.getSalesOrderNo() );
    map.put( "serviceNo", productReturnResultForm.getServiceNo() );
    map.put( "resultRemark", productReturnResultForm.getResultRemark() );
    map.put( "ownerCode", productReturnResultForm.getOwnerCode() );
    map.put( "resultCustName", productReturnResultForm.getResultCustName() );
    map.put( "resultIcMobileNo", productReturnResultForm.getResultIcMobileNo() );
    map.put( "resultReportEmailNo", productReturnResultForm.getResultReportEmailNo() );
    map.put( "resultAcceptanceName", productReturnResultForm.getResultAcceptanceName() );
    map.put( "transactionId", productReturnResultForm.getTransactionId() );
    map.put( "scanSerial", productReturnResultForm.getScanSerial() );
    map.put( "fraSerialNo", productReturnResultForm.getFraSerialNo() );
    map.put( "partnerCode", productReturnResultForm.getPartnerCode() );
    map.put( "partnerCodeName", productReturnResultForm.getPartnerCodeName() );
    list.add( map );
    return list;
  }
}
