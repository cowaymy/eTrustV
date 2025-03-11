package com.coway.trust.api.mobile.services.installation;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallationResultDto", description = "InstallationResultDto")
public class InstallationResultDto {
  @ApiModelProperty(value = "결과값")
  private String transactionId;

  public String getTransactionId() {
    return transactionId;
  }

  public void setTransactionId( String transactionId ) {
    this.transactionId = transactionId;
  }

  public static InstallationResultDto create( String transactionId ) {
    InstallationResultDto dto = new InstallationResultDto();
    dto.setTransactionId( transactionId );
    return dto;
  }
}
