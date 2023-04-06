package com.coway.trust.api.mobile.logistics.inventory;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "MyStockListSerialForm", description = "공통코드 Form")
public class InventoryOnHandStockSerialForm {

  @ApiModelProperty(value = "USER NAME", example = "CT100561")
  private String userId;

  @ApiModelProperty(value = "PART CODE", example = "112446")
  private String partsCode;

  @ApiModelProperty(value = "SERAIL NO", example = "13908ERI21A1504061")
  private String serialNo;

  public static Map<String, Object> createMap(InventoryOnHandStockSerialForm inventoryOnHandStockSerialForm) {
    Map<String, Object> params = new HashMap<>();
    params.put("userId", inventoryOnHandStockSerialForm.getUserId());
    params.put("partsCode", inventoryOnHandStockSerialForm.getPartsCode());
    params.put("serialNo", inventoryOnHandStockSerialForm.getSerialNo());
    return params;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public String getPartsCode() {
    return partsCode;
  }

  public void setPartsCode(String partsCode) {
    this.partsCode = partsCode;
  }

  public String getSerialNo() {
    return serialNo;
  }

  public void setSerialNo(String serialNo) {
    this.serialNo = serialNo;
  }
}
