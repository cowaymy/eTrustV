package com.coway.trust.api.mobile.logistics.inventory;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "Cody Consignment Transfer", description = "공통코드 Dto")
public class InventoryCodyOnHandStockDto {

  @ApiModelProperty(value = "Member ID ")
  private String memId;

  @ApiModelProperty(value = "Member Code")
  private String memCode;

  @ApiModelProperty(value = "Member Name")
  private String memName;

  @ApiModelProperty(value = "Stock id")
  private String stkId;

  @ApiModelProperty(value = "Stock Code")
  private String stkCde;

  @ApiModelProperty(value = "Stock Name")
  private String stkNm;

  @ApiModelProperty(value = "Type ID")
  private String itmTypId;

  @ApiModelProperty(value = "Type Name")
  private String itmTypNm;

  @ApiModelProperty(value = "WH ID")
  private String whId;

  @ApiModelProperty(value = "AvaQty")
  private String avaQty;

  public static InventoryCodyOnHandStockDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, InventoryCodyOnHandStockDto.class);
  }

  public String getMemId() {
    return memId;
  }

  public void setMemId(String memId) {
    this.memId = memId;
  }

  public String getMemCode() {
    return memCode;
  }

  public void setMemCode(String memCode) {
    this.memCode = memCode;
  }

  public String getMemName() {
    return memName;
  }

  public void setMemName(String memName) {
    this.memName = memName;
  }

  public String getStkId() {
    return stkId;
  }

  public void setStkId(String stkId) {
    this.stkId = stkId;
  }

  public String getStkCde() {
    return stkCde;
  }

  public void setStkCde(String stkCde) {
    this.stkCde = stkCde;
  }

  public String getStkNm() {
    return stkNm;
  }

  public void setStkNm(String stkNm) {
    this.stkNm = stkNm;
  }

  public String getItmTypId() {
    return itmTypId;
  }

  public void setItmTypId(String itmTypId) {
    this.itmTypId = itmTypId;
  }

  public String getItmTypNm() {
    return itmTypNm;
  }

  public void setItmTypNm(String itmTypNm) {
    this.itmTypNm = itmTypNm;
  }

  public String getWhId() {
    return whId;
  }

  public void setWhId(String whId) {
    this.whId = whId;
  }

  public String getAvaQty() {
    return avaQty;
  }

  public void setAvaQty(String avaQty) {
    this.avaQty = avaQty;
  }
}
