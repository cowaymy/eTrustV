package com.coway.trust.api.mobile.logistics.barcodeRegister;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "BarcodeRegisterApiDto", description = "공통코드 Dto")
public class BarcodeRegisterApiDto {
  @ApiModelProperty(value = "")
  private String scanNo;

  @ApiModelProperty(value = "")
  private String serialNo;

  @ApiModelProperty(value = "")
  private String itmCode;

  @ApiModelProperty(value = "")
  private String itmDesc;

  @SuppressWarnings("unchecked")
  public static BarcodeRegisterApiDto create( EgovMap egvoMap ) {
    return BeanConverter.toBean( egvoMap, BarcodeRegisterApiDto.class );
  }

  public String getScanNo() {
    return scanNo;
  }

  public void setScanNo( String scanNo ) {
    this.scanNo = scanNo;
  }

  public String getSerialNo() {
    return serialNo;
  }

  public void setSerialNo( String serialNo ) {
    this.serialNo = serialNo;
  }

  public String getItmCode() {
    return itmCode;
  }

  public void setItmCode( String itmCode ) {
    this.itmCode = itmCode;
  }

  public String getItmDesc() {
    return itmDesc;
  }

  public void setItmDesc( String itmDesc ) {
    this.itmDesc = itmDesc;
  }

}
