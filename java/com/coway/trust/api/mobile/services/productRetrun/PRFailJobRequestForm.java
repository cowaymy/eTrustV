package com.coway.trust.api.mobile.services.productRetrun;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.api.mobile.services.installation.InstallationResultForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class PRFailJobRequestForm {

  @ApiModelProperty(value = "사용자 ID (예_CT123456)")
  private String userId;

  @ApiModelProperty(value = "주문번호")
  private String salesOrderNo;

  @ApiModelProperty(value = "EX_BS00000 / AS00000")
  private String serviceNo;

  private String failReasonCode;

  private String handphoneTel;

  private String appTypeId;

  private String transactionId;

  private String failDeptChk;

  public String getTransactionId() {
    return transactionId;
  }

  public void setTransactionId(String transactionId) {
    this.transactionId = transactionId;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public String getHandphoneTel() {
	return handphoneTel;
}

public void setHandphoneTel(String handphoneTel) {
	this.handphoneTel = handphoneTel;
}

public String getAppTypeId() {
	return appTypeId;
}

public void setAppTypeId(String appTypeId) {
	this.appTypeId = appTypeId;
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

  public String getFailReasonCode() {
    return failReasonCode;
  }

  public void setFailReasonCode(String failReasonCode) {
    this.failReasonCode = failReasonCode;
  }

  public String getFailDeptChk() {
    return failDeptChk;
  }

  public void setFailDeptChk(String failDeptChk) {
    this.failDeptChk = failDeptChk;
  }

  public static Map<String, Object> createMaps(PRFailJobRequestForm pRFailJobRequestForm) {

    List<Map<String, Object>> list = new ArrayList<>();

    Map<String, Object> map = null;

    // map = BeanConverter.toMap(pRReAppointmentRequestForm, "signData", "partList");
    // map.put("signData", Base64.decodeBase64(installationResultForm.getSignData()));

    map = BeanConverter.toMap(pRFailJobRequestForm);

    // list.add(map);

    return map;
  }

}
