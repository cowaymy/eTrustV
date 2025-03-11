package com.coway.trust.api.mobile.services.productRetrun;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ProductRetrunJobForm", description = "공통코드 Form")
public class ProductRetrunJobForm {
  @ApiModelProperty(value = "userId [default : '' 전체] 예) CT100559 ", example = "1, 2, 3")
  private String userId;

  @ApiModelProperty(value = "requestDate [default : '' 전체] 예) 201706", example = "1, 2, 3")
  private String requestDate;

  public static Map<String, Object> createMap( ProductRetrunJobForm ProductRetrunJobForm ) {
    Map<String, Object> params = new HashMap<>();
    params.put( "userId", ProductRetrunJobForm.getUserId() );
    params.put( "requestDate", ProductRetrunJobForm.getRequestDate() );
    return params;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId( String userId ) {
    this.userId = userId;
  }

  public String getRequestDate() {
    return requestDate;
  }

  public void setRequestDate( String requestDate ) {
    this.requestDate = requestDate;
  }
}
