package com.coway.trust.api.mobile.logistics.inventory;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "Cody Consignment Transfer", description = "공통코드 Form")
public class InventoryCodyOnHandStockForm {

  @ApiModelProperty(value = "Mobile User Name", example = "CD100561")
  private String userId;

  @ApiModelProperty(value = "Input Text 1", example = "")
  private int txtSearch1;

  public static Map<String, Object> createMap(InventoryCodyOnHandStockForm InventoryCodyOnHandStockForm) {
    Map<String, Object> params = new HashMap<>();
    params.put("userId", InventoryCodyOnHandStockForm.getUserId());
    params.put("txtSearch1", InventoryCodyOnHandStockForm.getTxtSearch1());
    return params;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public int getTxtSearch1() {
    return txtSearch1;
  }

  public void setTxtSearch1(int txtSearch1) {
    this.txtSearch1 = txtSearch1;
  }

}
