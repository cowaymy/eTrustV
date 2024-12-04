package com.coway.trust.api.mobile.services.installation;

import java.util.Map;

import com.coway.trust.util.CommonUtils;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallFailJobRequestDto", description = "InstallFailJobRequestDto")
public class InstallFailJobRequestDto {
  @ApiModelProperty(value = "결과값")
  private String result;
  private String status;

  public String getResult() {
    return result;
  }

  public void setResult( String result ) {
    this.result = result;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus( String status ) {
    this.status = status;
  }

  public static InstallFailJobRequestDto create( String result ) {
    InstallFailJobRequestDto dto = new InstallFailJobRequestDto();
    dto.setResult( result );
    return dto;
  }

  public static InstallFailJobRequestDto create( Map<String, Object> rtnResultMap ) {
    InstallFailJobRequestDto dto = new InstallFailJobRequestDto();
    dto.setResult( CommonUtils.nvl(rtnResultMap.get( "result" )) );
    dto.setStatus( CommonUtils.nvl(rtnResultMap.get( "status" )) );
    return dto;
  }
}
