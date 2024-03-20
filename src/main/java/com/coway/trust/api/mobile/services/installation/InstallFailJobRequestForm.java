package com.coway.trust.api.mobile.services.installation;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.api.mobile.services.installation.InstallationResultForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 16/07/2020    ONGHC      1.0.1       - CREATE EXTRA GETTER & SETTER
 *********************************************************************************************/

public class InstallFailJobRequestForm {

  @ApiModelProperty(value = "사용자 ID (예_CT123456)")
  private String userId;

  @ApiModelProperty(value = "주문번호")
  private String salesOrderNo;

  @ApiModelProperty(value = "EX_BS00000 / AS00000")
  private String serviceNo;

  private String failReasonCode;

  private String serialNo;

  private String scanSerial;

  private String volt;

  private String psiRcd;

  private String lpmRcd;

  private String tds;

  private String roomTemp;

  private String waterSourceTemp;

  private String turbLvl;

  private String ntu;

  private String failLocCde;

  private String nxtCallDate;

  private String remark;

  private String failBfDepWH;

  private String resultIcMobileNo;

  private String failDeptChk;

  private String chkSms;

  private String checkSend;

  private String custMobileNo;

  public String getNtu() {
	return ntu;
}

public void setNtu(String ntu) {
	this.ntu = ntu;
}

public String getTurbLvl() {
	return turbLvl;
}

public void setTurbLvl(String turbLvl) {
	this.turbLvl = turbLvl;
}

public String getChkSms() {
	return chkSms;
}

public void setChkSms(String chkSms) {
	this.chkSms = chkSms;
}

public String getCheckSend() {
	return checkSend;
}

public void setCheckSend(String checkSend) {
	this.checkSend = checkSend;
}


public String getCustMobileNo() {
	return custMobileNo;
}

public void setCustMobileNo(String custMobileNo) {
	this.custMobileNo = custMobileNo;
}

public String getFailDeptChk() {
    return failDeptChk;
  }

  public void setFailDeptChk(String failDeptChk) {
    this.failDeptChk = failDeptChk;
  }

  public String getSerialNo() {
    return serialNo;
  }

  public void setSerialNo(String serialNo) {
    this.serialNo = serialNo;
  }

  public String getFailReasonCode() {
    return failReasonCode;
  }

  public void setFailReasonCode(String failReasonCode) {
    this.failReasonCode = failReasonCode;
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

  public String getScanSerial() {
    return scanSerial;
  }

  public void setScanSerial(String scanSerial) {
    this.scanSerial = scanSerial;
  }

  public String getVolt() {
    return volt;
  }

  public void setVolt(String volt) {
    this.volt = volt;
  }

  public String getPsiRcd() {
    return psiRcd;
  }

  public void setPsiRcd(String psiRcd) {
    this.psiRcd = psiRcd;
  }

  public String getLpmRcd() {
    return lpmRcd;
  }

  public void setLpmRcd(String lpmRcd) {
    this.lpmRcd = lpmRcd;
  }

  public String getTds() {
    return tds;
  }

  public void setTds(String tds) {
    this.tds = tds;
  }

  public String getRoomTemp() {
    return roomTemp;
  }

  public void setRoomTemp(String roomTemp) {
    this.roomTemp = roomTemp;
  }

  public String getWaterSourceTemp() {
    return waterSourceTemp;
  }

  public void setWaterSourceTemp(String waterSourceTemp) {
    this.waterSourceTemp = waterSourceTemp;
  }

  public String getFailLocCde() {
    return failLocCde;
  }

  public void setFailLocCde(String failLocCde) {
    this.failLocCde = failLocCde;
  }

  public String getNxtCallDate() {
    return nxtCallDate;
  }

  public void setNxtCallDate(String nxtCallDate) {
    this.nxtCallDate = nxtCallDate;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public String getFailBfDepWH() {
    return failBfDepWH;
  }

  public void setFailBfDepWH(String failBfDepWH) {
    this.failBfDepWH = failBfDepWH;
  }

  public String getResultIcMobileNo() {
	return resultIcMobileNo;
  }

  public void setResultIcMobileNo(String resultIcMobileNo) {
	this.resultIcMobileNo = resultIcMobileNo;
  }

public static Map<String, Object> createMaps(InstallFailJobRequestForm installFailJobRequestForm) {

    List<Map<String, Object>> list = new ArrayList<>();

    Map<String, Object> map = null;

    // map = BeanConverter.toMap(pRReAppointmentRequestForm, "signData", "partList");
    // map.put("signData", Base64.decodeBase64(installationResultForm.getSignData()));

    map = BeanConverter.toMap(installFailJobRequestForm);

    // list.add(map);

    return map;
  }

}
