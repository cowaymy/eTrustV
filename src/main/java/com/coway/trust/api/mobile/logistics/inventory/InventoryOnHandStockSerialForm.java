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
  private int partsCode;

  public static Map<String, Object> createMap(InventoryOnHandStockSerialForm inventoryOnHandStockSerialForm) {
    Map<String, Object> params = new HashMap<>();
    params.put("userId", inventoryOnHandStockSerialForm.getUserId());
    params.put("partsCode", inventoryOnHandStockSerialForm.getPartsCode());
    return params;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public int getPartsCode() {
    return partsCode;
  }

  public void setPartsCode(int partsCode) {
    this.partsCode = partsCode;
  }
}
