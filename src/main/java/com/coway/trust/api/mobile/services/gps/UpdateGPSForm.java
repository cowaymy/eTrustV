package com.coway.trust.api.mobile.services.gps;

import java.util.HashMap;
import java.util.Map;

//import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;


@ApiModel(value = "UpdateGPSForm", description = "Update GPS Form")
public class UpdateGPSForm {

  @ApiModelProperty(value = "")
  private String currentGpsValLat;

  @ApiModelProperty(value = "")
  private String currentGpsValLong;

  @ApiModelProperty(value = "")
  private String salesOrderNo;

  @ApiModelProperty(value = "")
  private String crtUserId;

  public String getCurrentGpsValLat() {
    return currentGpsValLat;
  }

  public void setCurrentGpsValLat(String currentGpsValLat) {
    this.currentGpsValLat = currentGpsValLat;
  }

  public String getCurrentGpsValLong() {
    return currentGpsValLong;
  }

  public void setCurrentGpsValLong(String currentGpsValLong) {
    this.currentGpsValLong = currentGpsValLong;
  }

  public String getSalesOrderNo() {
    return salesOrderNo;
  }

  public void setSalesOrderNo(String salesOrderNo) {
    this.salesOrderNo = salesOrderNo;
  }

  public String getCrtUserId() {
    return crtUserId;
  }

  public void setCrtUserId(String crtUserId) {
    this.crtUserId = crtUserId;
  }

  public static Map<String, Object> createMap(UpdateGPSForm updateGpsForm){
      Map<String, Object> params = new HashMap<>();

      params.put("userId", updateGpsForm.getCrtUserId());
      params.put("salesOrderNo", 	updateGpsForm.getSalesOrderNo());
      params.put("currentGpsValLat", updateGpsForm.getCurrentGpsValLat());
      params.put("currentGpsValLong", updateGpsForm.getCurrentGpsValLong());

      return params;
    }
}
