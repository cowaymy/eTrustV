package com.coway.trust.api.mobile.services.productRetrun;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ProductReturnResultDto", description = "ProductReturnResultDto")
public class ProductReturnResultDto {
  @ApiModelProperty(value = "결과값")
  private String result;

  public String getResult() {
    return result;
  }

  public void setResult( String result ) {
    this.result = result;
  }

  public static ProductReturnResultDto create( String result ) {
    ProductReturnResultDto dto = new ProductReturnResultDto();
    dto.setResult( result );
    return dto;
  }
}
