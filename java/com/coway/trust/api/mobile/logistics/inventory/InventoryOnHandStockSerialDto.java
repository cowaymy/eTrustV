package com.coway.trust.api.mobile.logistics.inventory;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "MyStockListDto", description = "공통코드 Dto")
public class InventoryOnHandStockSerialDto {

  @ApiModelProperty(value = "PART CODE")
  private String partCode;

  @ApiModelProperty(value = "PART NAME")
  private String partName;

  @ApiModelProperty(value = "SERIAL NUMBER")
  private String serialNo;

  @ApiModelProperty(value = "GR DATE")
  private String grDate;

  @SuppressWarnings("unchecked")
  public static InventoryOnHandStockSerialDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, InventoryOnHandStockSerialDto.class);
  }

  public String getPartCode() {
    return partCode;
  }

  public void setPartCode(String partCode) {
    this.partCode = partCode;
  }

  public String getPartName() {
    return partName;
  }

  public void setPartName(String partName) {
    this.partName = partName;
  }

  public String getSerialNo() {
    return serialNo;
  }

  public void setSerialNo(String serialNo) {
    this.serialNo = serialNo;
  }

  public String getGrDate() {
    return grDate;
  }

  public void setGrDate(String grDate) {
    this.grDate = grDate;
  }
}
