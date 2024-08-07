package com.coway.trust.api.mobile.services.careService;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.api.mobile.services.as.AfterServiceResultDetailForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;
//import com.coway.trust.api.mobile.common.MalfunctionCodeForm;
import com.coway.trust.util.BeanConverter;
import com.crystaldecisions.Utilities.Logger;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 10/04/2019    ONGHC      1.0.1       - Amend File Format
 * 13/08/2019    ONGHC      1.0.2       - Add Variable faucetExch
 *********************************************************************************************/

@ApiModel(value = "HeartServiceResultForm", description = "HeartServiceResultForm")
public class CareServiceResultForm {

  @ApiModelProperty(value = "사용자 ID (예_CT123456)")
  private String userId;

  @ApiModelProperty(value = "주문번호")
  private String salesOrderNo;

  @ApiModelProperty(value = "EX_BS00000 / AS00000")
  private String serviceNo;

  @ApiModelProperty(value = "Y/ N")
  private String temperatureSetting;

  @ApiModelProperty(value = "0/ 1")
  private String faucetExch;

  @ApiModelProperty(value = "결과 등록 메모")
  private String resultRemark;

  @ApiModelProperty(value = "다음 작업 날짜(YYYYMMDD)")
  private String nextAppointmentDate;

  @ApiModelProperty(value = "다음 작업 시간(HHMM)")
  private String nextAppointmentTime;

  @ApiModelProperty(value = "결과 등록시, Owner Code")
  private int ownerCode;

  @ApiModelProperty(value = "결과 등록시, Cust Name")
  private String resultCustName;

  @ApiModelProperty(value = "결과 등록시, NrIc 또는 Mobile No")
  private String resultIcMobileNo;

  @ApiModelProperty(value = "결과 등록시, Email_No")
  private String resultReportEmailNo;

  @ApiModelProperty(value = "결과 등록시, Acceptance Name")
  private String resultAcceptanceName;

  @ApiModelProperty(value = "")
  private int rcCode;

  @ApiModelProperty(value = "base64 Data")
  private String signData;

  @ApiModelProperty(value = "")
  private String signRegDate;

  @ApiModelProperty(value = "")
  private String signRegTime;

  @ApiModelProperty(value = "Transaction ID 값(체계 : USER_ID + SALES_ORDER_NO + SERVICE_NO + 현재시간_YYYYMMDDHHMMSS)")
  private String transactionId;

  private String checkInDate;
  private String checkInTime;
  private String checkInGps;

  public String getCheckInDate() {
    return checkInDate;
  }

  public void setCheckInDate(String checkInDate) {
    this.checkInDate = checkInDate;
  }

  public String getCheckInTime() {
    return checkInTime;
  }

  public void setCheckInTime(String checkInTime) {
    this.checkInTime = checkInTime;
  }

  public String getCheckInGps() {
    return checkInGps;
  }

  public void setCheckInGps(String checkInGps) {
    this.checkInGps = checkInGps;
  }

  @ApiModelProperty(value = "heartDtails")
  private List<CareServiceResultDetailForm> heartDtails;

  public String getSignRegDate() {
    return signRegDate;
  }

  public void setSignRegDate(String signRegDate) {
    this.signRegDate = signRegDate;
  }

  public String getSignRegTime() {
    return signRegTime;
  }

  public void setSignRegTime(String signRegTime) {
    this.signRegTime = signRegTime;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public String getSalesOrderNo() {
    return salesOrderNo;
  }

  public void setSalesOrderNo(String salesOrderNo) {
    this.salesOrderNo = salesOrderNo;
  }

  public String getServiceNo() {
    return serviceNo;
  }

  public void setServiceNo(String serviceNo) {
    this.serviceNo = serviceNo;
  }

  public String getTemperatureSetting() {
    return temperatureSetting;
  }

  public void setTemperatureSetting(String temperatureSetting) {
    this.temperatureSetting = temperatureSetting;
  }

  public String getFaucetExch() {
    return faucetExch;
  }

  public void setFaucetExch(String faucetExch) {
    this.faucetExch = faucetExch;
  }

  public String getResultRemark() {
    return resultRemark;
  }

  public void setResultRemark(String resultRemark) {
    this.resultRemark = resultRemark;
  }

  public String getNextAppointmentDate() {
    return nextAppointmentDate;
  }

  public void setNextAppointmentDate(String nextAppointmentDate) {
    this.nextAppointmentDate = nextAppointmentDate;
  }

  public String getNextAppointmentTime() {
    return nextAppointmentTime;
  }

  public void setNextAppointmentTime(String nextAppointmentTime) {
    this.nextAppointmentTime = nextAppointmentTime;
  }

  public int getOwnerCode() {
    return ownerCode;
  }

  public void setOwnerCode(int ownerCode) {
    this.ownerCode = ownerCode;
  }

  public String getResultCustName() {
    return resultCustName;
  }

  public void setResultCustName(String resultCustName) {
    this.resultCustName = resultCustName;
  }

  public String getResultIcMobileNo() {
    return resultIcMobileNo;
  }

  public void setResultIcMobileNo(String resultIcMobileNo) {
    this.resultIcMobileNo = resultIcMobileNo;
  }

  public String getResultReportEmailNo() {
    return resultReportEmailNo;
  }

  public void setResultReportEmailNo(String resultReportEmailNo) {
    this.resultReportEmailNo = resultReportEmailNo;
  }

  public String getResultAcceptanceName() {
    return resultAcceptanceName;
  }

  public void setResultAcceptanceName(String resultAcceptanceName) {
    this.resultAcceptanceName = resultAcceptanceName;
  }

  public int getRcCode() {
    return rcCode;
  }

  public void setRcCode(int rcCode) {
    this.rcCode = rcCode;
  }

  public String getSignData() {
    return signData;
  }

  public void setSignData(String signData) {
    this.signData = signData;
  }

  public String getTransactionId() {
    return transactionId;
  }

  public void setTransactionId(String transactionId) {
    this.transactionId = transactionId;
  }

  public List<CareServiceResultDetailForm> getHeartDtails() {
    return heartDtails;
  }

  public void setHeartDtails(List<CareServiceResultDetailForm> heartDtails) {
    this.heartDtails = heartDtails;
  }

  public List<Map<String, Object>> createMaps(CareServiceResultForm heartServiceResultForm) {

    List<Map<String, Object>> list = new ArrayList<>();

    if (heartDtails != null && heartDtails.size() > 0) {
      Map<String, Object> map;
      for (CareServiceResultDetailForm dtl : heartDtails) {
        map = BeanConverter.toMap(heartServiceResultForm, "signData", "heartDtails");
        map.put("signData", Base64.decodeBase64(heartServiceResultForm.getSignData()));

        // heartDtails
        map.put("filterCode", dtl.getFilterCode());
        map.put("exchangeId", dtl.getExchangeId());
        map.put("filterChangeQty", dtl.getFilterChangeQty());
        map.put("alternativeFilterCode", dtl.getAlternativeFilterCode());
        map.put("filterBarcdSerialNo", dtl.getFilterBarcdSerialNo());

        list.add(map);
      }
    }
    return list;
  }

  public List<Map<String, Object>> createMaps1(CareServiceResultForm heartServiceResultForm) {

    List<Map<String, Object>> list = new ArrayList<>();

    if (heartDtails != null && heartDtails.size() > 0) {
      Map<String, Object> map;
      map = BeanConverter.toMap(heartServiceResultForm, "signData");
      map.put("signData", Base64.decodeBase64(heartServiceResultForm.getSignData()));

      for (CareServiceResultDetailForm obj : heartDtails) {
        map.put("filterCode", obj.getFilterCode());
        map.put("exchangeId", obj.getExchangeId());
        map.put("filterChangeQty", obj.getFilterChangeQty());
        map.put("filterBarcdSerialNo", obj.getFilterBarcdSerialNo());

        list.add(map);
      }
    }

    return list;
  }

}
