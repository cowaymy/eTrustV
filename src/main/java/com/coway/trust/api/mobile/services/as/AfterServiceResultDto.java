package com.coway.trust.api.mobile.services.as;

import java.util.Map;

import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;
import com.coway.trust.api.mobile.services.installation.InstallFailJobRequestDto;
import com.coway.trust.util.CommonUtils;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceResultDto", description = "AfterServiceResultDto")
public class AfterServiceResultDto {
  @ApiModelProperty(value = "결과값")
  private String transactionId;
  private String status;

  public String getTransactionId() {
    return transactionId;
  }

  public void setTransactionId( String transactionId ) {
    this.transactionId = transactionId;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus( String status ) {
    this.status = status;
  }

  public static AfterServiceResultDto create( String transactionId ) {
    AfterServiceResultDto dto = new AfterServiceResultDto();
    dto.setTransactionId( transactionId );
    return dto;
  }

  public static AfterServiceResultDto create( Map<String, Object> rtnResultMap ) {
    AfterServiceResultDto dto = new AfterServiceResultDto();
    dto.setTransactionId( CommonUtils.nvl(rtnResultMap.get( "result" )) );
    dto.setStatus( CommonUtils.nvl(rtnResultMap.get( "status" )) );
    return dto;
  }
}
