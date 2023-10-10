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
  private String txtSearch1;

  @ApiModelProperty(value = "Input Text 2", example = "")
  private String txtSearch2;

  @ApiModelProperty(value = "Input Text 3", example = "")
  private String txtSearch3;

  public static Map<String, Object> createMap(InventoryCodyOnHandStockForm InventoryCodyOnHandStockForm) {
    Map<String, Object> params = new HashMap<>();
    params.put("userId", InventoryCodyOnHandStockForm.getUserId());
    params.put("txtSearch1", InventoryCodyOnHandStockForm.getTxtSearch1());
    params.put("txtSearch2", InventoryCodyOnHandStockForm.getTxtSearch2());
    params.put("txtSearch3", InventoryCodyOnHandStockForm.getTxtSearch3());
    return params;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public String getTxtSearch1() {
    return txtSearch1;
  }

  public void setTxtSearch1(String txtSearch1) {
    this.txtSearch1 = txtSearch1;
  }

  public String getTxtSearch2() {
    return txtSearch2;
  }

  public void setTxtSearch2(String txtSearch2) {
    this.txtSearch2 = txtSearch2;
  }

  public String getTxtSearch3() {
    return txtSearch3;
  }

  public void setTxtSearch3(String txtSearch3) {
    this.txtSearch3 = txtSearch3;
  }
}
