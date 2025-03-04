package com.coway.trust.api.mobile.services.installation;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallationJobForm", description = "공통코드 Form")
public class InstallationJobForm {
  @ApiModelProperty(value = "USER ID")
  private String userId;

  @ApiModelProperty(value = "REQUEST DATE")
  private String requestDate;

  public static Map<String, Object> createMap( InstallationJobForm InstallationJobForm ) {
    Map<String, Object> params = new HashMap<>();
    params.put( "userId", InstallationJobForm.getUserId() );
    params.put( "requestDate", InstallationJobForm.getRequestDate() );
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
