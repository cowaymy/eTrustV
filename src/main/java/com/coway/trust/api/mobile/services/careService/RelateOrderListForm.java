package com.coway.trust.api.mobile.services.careService;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/*********************************************************************************************
 * DATE             PIC           VERSION  COMMENT
 * -----------------------------------------------------------------------------
 * 22/04/2020    ONGHC      1.0.0       - Create RelateOrderListForm
 *********************************************************************************************/

@ApiModel(value = "RelateOrderListForm", description = "Order List")
public class RelateOrderListForm {

  @ApiModelProperty(value = "userId", example = "1, 2, 3")
  private String userId;

  @ApiModelProperty(value = "custId", example = "1, 2, 3")
  private String custId;

  public static Map<String, Object> createMaps(RelateOrderListForm RelateOrderListForm) {
    Map<String, Object> params = new HashMap<>();
    params.put("userId", RelateOrderListForm.getUserId());
    params.put("custId", RelateOrderListForm.getCustId());
    return params;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public String getCustId() {
    return custId;
  }

  public void setCustId(String custId) {
    this.custId = custId;
  }
}
